import json
import logging
from contextlib import contextmanager
from typing import Any, Dict, List, Optional
from enum import Enum

import psycopg2
from psycopg2.extras import Json
from psycopg2 import sql
from server.src.config import settings

logger = logging.getLogger(__name__)


class TaskStatus(str, Enum):
    PENDING = "pending"
    RUNNING = "running"
    PAUSED = "paused"
    COMPLETED = "completed"
    FAILED = "failed"


class DatabaseManager:
    def __init__(self, connection_url: str):
        self.connection_url = connection_url

    @contextmanager
    def get_connection(self):
        conn = None
        try:
            conn = psycopg2.connect(self.connection_url)
            yield conn
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"Database connection error: {e}")
            raise
        finally:
            if conn:
                conn.close()

    @contextmanager
    def get_cursor(self):
        with self.get_connection() as conn:
            cursor = conn.cursor()
            try:
                yield cursor, conn
            finally:
                cursor.close()


class SourceDatabase(DatabaseManager):
    def reassign_item_references(self, cursor, source_item_id: int, target_item_id: int):
        if source_item_id == target_item_id:
            return

        cursor.execute(
            """
                SELECT
                    src_ns.nspname AS source_schema,
                    src.relname AS source_table,
                    src_att.attname AS source_column
                FROM pg_constraint con
                JOIN pg_class src
                    ON src.oid = con.conrelid
                JOIN pg_namespace src_ns
                    ON src_ns.oid = src.relnamespace
                JOIN pg_class tgt
                    ON tgt.oid = con.confrelid
                JOIN pg_namespace tgt_ns
                    ON tgt_ns.oid = tgt.relnamespace
                JOIN unnest(con.conkey) WITH ORDINALITY AS src_col(attnum, ord)
                    ON TRUE
                JOIN unnest(con.confkey) WITH ORDINALITY AS tgt_col(attnum, ord)
                    ON src_col.ord = tgt_col.ord
                JOIN pg_attribute src_att
                    ON src_att.attrelid = src.oid
                    AND src_att.attnum = src_col.attnum
                JOIN pg_attribute tgt_att
                    ON tgt_att.attrelid = tgt.oid
                    AND tgt_att.attnum = tgt_col.attnum
                WHERE con.contype = 'f'
                    AND tgt_ns.nspname = 'public'
                    AND tgt.relname = 'items'
                    AND tgt_att.attname = 'id'
                    AND cardinality(con.conkey) = 1
                    AND cardinality(con.confkey) = 1
            """
        )
        references = cursor.fetchall()

        for source_schema, source_table, source_column in references:
            update_sql = sql.SQL("""
                UPDATE {schema}.{table}
                SET {column} = %s
                WHERE {column} = %s
            """).format(
                schema=sql.Identifier(source_schema),
                table=sql.Identifier(source_table),
                column=sql.Identifier(source_column),
            )
            cursor.execute(update_sql, (target_item_id, source_item_id))

    @staticmethod
    def normalize_pipeline_result(recommendations: Any) -> Dict[str, Any]:
        if recommendations is None:
            return {"results": []}

        if isinstance(recommendations, str):
            try:
                recommendations = json.loads(recommendations)
            except json.JSONDecodeError:
                return {"results": [], "message": recommendations}

        if isinstance(recommendations, list):
            return {"results": recommendations}

        if isinstance(recommendations, dict):
            results = recommendations.get("results")
            message = recommendations.get("message")
            if isinstance(results, list):
                payload: Dict[str, Any] = {"results": results}
                if message:
                    payload["message"] = message
                return payload

            if all(key in recommendations for key in ("title_one", "title_two", "distance")):
                return {"results": [recommendations]}

            if message:
                return {"results": [], "message": message}

        return {"results": [], "message": "Unsupported recommendations payload"}

    @staticmethod
    def filter_unresolved_recommendations(
        recommendations: Any,
        pairs_to_resolve: List[Dict[str, Any]],
    ) -> Dict[str, Any]:
        normalized = SourceDatabase.normalize_pipeline_result(recommendations)
        results = normalized.get("results", [])
        if not results or not pairs_to_resolve:
            return normalized

        def apply_group_resolution(
            recommendation: Dict[str, Any],
            payload: Dict[str, Any],
        ) -> Optional[Dict[str, Any]]:
            recommendation_items = recommendation.get("items")
            payload_items = payload.get("items")
            if not isinstance(recommendation_items, list) or not isinstance(payload_items, list):
                return recommendation

            recommendation_item_ids = [
                item.get("item_id")
                for item in recommendation_items
                if item.get("item_id") is not None
            ]
            payload_item_ids = [
                item.get("item_id")
                for item in payload_items
                if item.get("item_id") is not None
            ]
            if len(recommendation_item_ids) < 2 or len(payload_item_ids) < 2:
                return recommendation

            recommendation_anchor_id = (
                recommendation.get("anchor_item_id") or recommendation_item_ids[0]
            )
            payload_anchor_id = payload.get("anchor_item_id") or payload_item_ids[0]
            if recommendation_anchor_id != payload_anchor_id:
                return recommendation

            if not set(payload_item_ids).issubset(set(recommendation_item_ids)):
                return recommendation

            resolved_duplicate_ids = {
                item_id
                for item_id in payload_item_ids
                if item_id != recommendation_anchor_id
            }
            if not resolved_duplicate_ids:
                return recommendation

            remaining_items = [
                item
                for item in recommendation_items
                if item.get("item_id") not in resolved_duplicate_ids
            ]
            if len(remaining_items) < 2:
                return None

            updated_recommendation = dict(recommendation)
            updated_recommendation["items"] = remaining_items
            return updated_recommendation

        def pair_key(payload: Dict[str, Any]) -> tuple[Any, ...]:
            items = payload.get("items")
            if isinstance(items, list) and items:
                item_ids = tuple(
                    item.get("item_id")
                    for item in items
                    if item.get("item_id") is not None
                )
                if item_ids:
                    return ("group", *item_ids)

            if payload.get("item_one_id") is not None and payload.get("item_two_id") is not None:
                return ("id", payload.get("item_one_id"), payload.get("item_two_id"))
            return ("title", payload.get("title_one"), payload.get("title_two"))

        resolved_keys = {pair_key(pair) for pair in pairs_to_resolve}

        remaining_results = []
        for recommendation in results:
            current_recommendation: Optional[Dict[str, Any]] = recommendation

            for pair in pairs_to_resolve:
                if current_recommendation is None:
                    break
                current_recommendation = apply_group_resolution(current_recommendation, pair)

            if current_recommendation is None:
                continue

            if pair_key(current_recommendation) in resolved_keys:
                continue

            remaining_results.append(current_recommendation)

        payload: Dict[str, Any] = {"results": remaining_results}
        if normalized.get("message"):
            payload["message"] = normalized["message"]
        return payload

    def get_identifiers(self) -> List[Dict[str, Any]]:
        with self.get_cursor() as (cursor, conn):
            cursor.execute("""
                SELECT
                    id,
                    COALESCE(name::json->>'en', name::json->>'ru') AS name,
                    path::text AS path,
                    "typeId",
                    "typeIdentifier",
                    "updatedAt"
                FROM items
                WHERE "deletedAt" IS NULL
            """)
            rows = cursor.fetchall()
            return [
                {
                    "item_id": row[0],
                    "name": row[1],
                    "path": row[2],
                    "type_id": row[3],
                    "type_identifier": row[4],
                    "updated_at": row[5],
                }
                for row in rows
                if row[1]
            ]

    def get_identifiers_with_vector_metadata(self) -> List[Dict[str, Any]]:
        with self.get_cursor() as (cursor, conn):
            cursor.execute("""
                SELECT
                    i.id,
                    COALESCE(i.name::json->>'en', i.name::json->>'ru') AS name,
                    i.path::text AS path,
                    i."typeId",
                    i."typeIdentifier",
                    i."updatedAt",
                    vd.input_hash,
                    vd.model,
                    vd.source_updated_at
                FROM items AS i
                LEFT JOIN vector_data AS vd
                    ON vd.item_id = i.id
                WHERE i."deletedAt" IS NULL
            """)
            rows = cursor.fetchall()
            return [
                {
                    "item_id": row[0],
                    "name": row[1],
                    "path": row[2],
                    "type_id": row[3],
                    "type_identifier": row[4],
                    "updated_at": row[5],
                    "stored_vector_input_hash": row[6],
                    "vector_model": row[7],
                    "vector_source_updated_at": row[8],
                }
                for row in rows
                if row[1]
            ]

    def setup_vector_extension(self):
        with self.get_cursor() as (cursor, conn):
            cursor.execute("CREATE EXTENSION IF NOT EXISTS vector;")
            conn.commit()

    def create_vector_table(self):
        create_table_sql = """
            CREATE TABLE IF NOT EXISTS vector_data (
                id SERIAL PRIMARY KEY,
                item_id BIGINT UNIQUE NOT NULL,
                identifier TEXT NOT NULL,
                vector vector(768) NOT NULL,
                input_hash TEXT,
                source_updated_at TIMESTAMPTZ,
                vectorized_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                model TEXT
            )
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(create_table_sql)
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS item_id BIGINT"
            )
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS identifier TEXT"
            )
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS input_hash TEXT"
            )
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS source_updated_at TIMESTAMPTZ"
            )
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS vectorized_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP"
            )
            cursor.execute(
                "ALTER TABLE vector_data ADD COLUMN IF NOT EXISTS model TEXT"
            )
            cursor.execute(
                "CREATE UNIQUE INDEX IF NOT EXISTS idx_vector_data_item_id ON vector_data(item_id)"
            )
            cursor.execute(
                "ALTER TABLE vector_data DROP CONSTRAINT IF EXISTS vector_data_identifier_key"
            )
            cursor.execute(
                "DROP INDEX IF EXISTS vector_data_identifier_key"
            )
            conn.commit()

    def insert_or_update_vector(
        self,
        item_id: int,
        identifier: str,
        vector: List[float],
        input_hash: Optional[str] = None,
        source_updated_at: Optional[Any] = None,
        model: Optional[str] = None,
    ):
        insert_sql = """
            INSERT INTO vector_data (
                item_id,
                identifier,
                vector,
                input_hash,
                source_updated_at,
                vectorized_at,
                model
            )
            VALUES (%s, %s, %s, %s, %s, CURRENT_TIMESTAMP, %s)
            ON CONFLICT (item_id) DO UPDATE
            SET identifier = EXCLUDED.identifier,
                vector = EXCLUDED.vector,
                input_hash = EXCLUDED.input_hash,
                source_updated_at = EXCLUDED.source_updated_at,
                vectorized_at = CURRENT_TIMESTAMP,
                model = EXCLUDED.model
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(
                insert_sql,
                (item_id, identifier, vector, input_hash, source_updated_at, model),
            )
            conn.commit()

    def get_close_groups(self) -> List[Dict[str, Any]]:
        query_items_sql = """
            SELECT id, item_id, identifier
            FROM vector_data
            ORDER BY id
        """
        query_group_sql = """
            SELECT
                other.id,
                other.item_id,
                other.identifier,
                base.vector <=> other.vector AS distance
            FROM vector_data AS base
            JOIN vector_data AS other
                ON other.id = ANY(%s)
            WHERE base.id = %s
                AND (base.vector <=> other.vector) < %s
            ORDER BY distance, other.id
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(query_items_sql)
            rows = cursor.fetchall()

            ordered_vector_ids = [row[0] for row in rows]
            remaining_items = {
                row[0]: {
                    "item_id": row[1],
                    "title": row[2],
                }
                for row in rows
            }
            groups: List[Dict[str, Any]] = []

            while ordered_vector_ids:
                base_vector_id = ordered_vector_ids.pop(0)
                base_item = remaining_items.pop(base_vector_id, None)
                if not base_item:
                    continue

                candidate_vector_ids = list(remaining_items.keys())
                if not candidate_vector_ids:
                    continue

                cursor.execute(
                    query_group_sql,
                    (candidate_vector_ids, base_vector_id, settings.duplicate_distance_threshold),
                )
                matched_rows = cursor.fetchall()
                if not matched_rows:
                    continue

                group_items = [
                    {
                        "item_id": base_item["item_id"],
                        "title": base_item["title"],
                        "distance": 0.0,
                        "is_anchor": True,
                    }
                ]
                matched_vector_ids: List[int] = []

                for row in matched_rows:
                    matched_vector_id = row[0]
                    matched_item = remaining_items.pop(matched_vector_id, None)
                    if not matched_item:
                        continue

                    matched_vector_ids.append(matched_vector_id)
                    group_items.append(
                        {
                            "item_id": row[1],
                            "title": row[2],
                            "distance": float(row[3]),
                            "is_anchor": False,
                        }
                    )

                if len(group_items) > 1:
                    groups.append(
                        {
                            "anchor_item_id": base_item["item_id"],
                            "items": group_items,
                        }
                    )

                if matched_vector_ids:
                    matched_vector_ids_set = set(matched_vector_ids)
                    ordered_vector_ids = [
                        vector_id
                        for vector_id in ordered_vector_ids
                        if vector_id not in matched_vector_ids_set
                    ]

            return groups

    def create_pipeline_tables(self):
        create_archive_table = """
            CREATE TABLE IF NOT EXISTS items_archive (LIKE items INCLUDING ALL)
        """

        create_tasks_table = """
            CREATE TABLE IF NOT EXISTS pipeline_tasks (
                id SERIAL PRIMARY KEY,
                task_id UUID UNIQUE NOT NULL,
                status VARCHAR(20) NOT NULL DEFAULT 'pending',
                started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                completed_at TIMESTAMP,
                paused_at TIMESTAMP,
                error TEXT,
                current_step INTEGER DEFAULT 0,
                total_steps INTEGER DEFAULT 5,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
        """

        create_results_table = """
            CREATE TABLE IF NOT EXISTS pipeline_results (
                task_id UUID PRIMARY KEY REFERENCES pipeline_tasks(task_id) ON DELETE CASCADE,
                recommendations JSONB,
                error TEXT,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
        """

        create_indexes = """
            CREATE INDEX IF NOT EXISTS idx_pipeline_tasks_status ON pipeline_tasks(status);
            CREATE INDEX IF NOT EXISTS idx_pipeline_tasks_task_id ON pipeline_tasks(task_id);
        """

        with self.get_cursor() as (cursor, conn):
            cursor.execute(create_archive_table)
            cursor.execute(create_tasks_table)
            cursor.execute(create_results_table)
            cursor.execute(create_indexes)
            conn.commit()

    def create_pipeline_task(self, task_id: str, total_steps: int = 5):
        insert_sql = """
            INSERT INTO pipeline_tasks (task_id, status, total_steps)
            VALUES (%s, %s, %s)
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(insert_sql, (task_id, TaskStatus.PENDING.value, total_steps))
            conn.commit()

    def delete_pipeline_task(self, task_id: str):
        delete_sql = """
            DELETE FROM pipeline_tasks
            WHERE task_id = %s
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(delete_sql, (task_id,))
            conn.commit()

    def get_pipeline_task(self, task_id: str) -> Optional[Dict]:
        select_sql = """
            SELECT task_id, status, started_at, completed_at, paused_at,
                   error, current_step, total_steps
            FROM pipeline_tasks
            WHERE task_id = %s
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(select_sql, (task_id,))
            row = cursor.fetchone()
            if not row:
                return None
            return {
                "task_id": str(row[0]),
                "status": row[1],
                "started_at": row[2].isoformat() if row[2] else None,
                "completed_at": row[3].isoformat() if row[3] else None,
                "paused_at": row[4].isoformat() if row[4] else None,
                "error": row[5],
                "current_step": row[6],
                "total_steps": row[7]
            }

    def update_pipeline_task_status(
        self,
        task_id: str,
        status: str,
        current_step: Optional[int] = None,
        error: Optional[str] = None,
    ):
        update_sql = """
            UPDATE pipeline_tasks
            SET status = %s,
                updated_at = CURRENT_TIMESTAMP
        """
        params = [status]

        if status == TaskStatus.RUNNING.value:
            update_sql += ", started_at = COALESCE(started_at, CURRENT_TIMESTAMP)"
        elif status == TaskStatus.COMPLETED.value or status == TaskStatus.FAILED.value:
            update_sql += ", completed_at = CURRENT_TIMESTAMP"
        elif status == TaskStatus.PAUSED.value:
            update_sql += ", paused_at = CURRENT_TIMESTAMP"

        if current_step is not None:
            update_sql += ", current_step = %s"
            params.append(current_step)

        if error is not None:
            update_sql += ", error = %s"
            params.append(error)

        update_sql += " WHERE task_id = %s"
        params.append(task_id)

        with self.get_cursor() as (cursor, conn):
            cursor.execute(update_sql, params)
            conn.commit()

    def pause_pipeline_task(self, task_id: str):
        self.update_pipeline_task_status(task_id, TaskStatus.PAUSED.value)

    def resume_pipeline_task(self, task_id: str):
        self.update_pipeline_task_status(task_id, TaskStatus.RUNNING.value)

    def get_all_pipeline_tasks(self) -> List[Dict]:
        select_sql = """
            SELECT task_id, status, started_at, completed_at, paused_at,
                   error, current_step, total_steps
            FROM pipeline_tasks
            ORDER BY created_at DESC
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(select_sql)
            rows = cursor.fetchall()
            return [
                {
                    "task_id": str(row[0]),
                    "status": row[1],
                    "started_at": row[2].isoformat() if row[2] else None,
                    "completed_at": row[3].isoformat() if row[3] else None,
                    "paused_at": row[4].isoformat() if row[4] else None,
                    "error": row[5],
                    "current_step": row[6],
                    "total_steps": row[7]
                }
                for row in rows
            ]

    def save_pipeline_result(self, task_id: str, recommendations: Any, error: Optional[str] = None):
        payload = self.normalize_pipeline_result(recommendations)
        insert_sql = """
            INSERT INTO pipeline_results (task_id, recommendations, error, updated_at)
            VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
            ON CONFLICT (task_id) DO UPDATE
            SET recommendations = EXCLUDED.recommendations,
                error = EXCLUDED.error,
                updated_at = CURRENT_TIMESTAMP
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(
                insert_sql,
                (task_id, Json(payload) if payload is not None else None, error)
            )
            conn.commit()

    def get_pipeline_final_result(self, task_id: str) -> Optional[Any]:
        try:
            select_sql = """
                SELECT recommendations
                FROM pipeline_results
                WHERE task_id = %s
            """
            with self.get_cursor() as (cursor, conn):
                cursor.execute(select_sql, (task_id,))
                row = cursor.fetchone()
                if row and row[0]:
                    return self.normalize_pipeline_result(row[0])
                return None
        except Exception as e:
            logger.error(f"Error getting pipeline result for task {task_id}: {e}")
            return None

    def remove_resolved_pairs_from_result(self, task_id: str, pairs_to_resolve: List[Dict[str, Any]]):
        if not pairs_to_resolve:
            return

        recommendations = self.get_pipeline_final_result(task_id)
        if recommendations is None:
            return

        remaining_recommendations = self.filter_unresolved_recommendations(
            recommendations,
            pairs_to_resolve,
        )
        self.save_pipeline_result(task_id, remaining_recommendations)

    def resolve_pipeline_result(self, pairs_to_resolve: List[Dict[str, Any]]) -> int:
        if not pairs_to_resolve:
            return 0

        processed_count = 0

        with self.get_cursor() as (cursor, conn):
            for pair in pairs_to_resolve:
                items = pair.get("items")
                if isinstance(items, list) and items:
                    item_ids = [
                        item.get("item_id")
                        for item in items
                        if item.get("item_id") is not None
                    ]
                    if len(item_ids) < 2:
                        continue

                    anchor_item_id = pair.get("anchor_item_id") or item_ids[0]
                    duplicate_item_ids = [
                        item_id for item_id in item_ids
                        if item_id != anchor_item_id
                    ]
                    suggested_name = pair.get("suggested_name") or pair.get("suggest_name")
                    action = pair.get("action", "merge")

                    if not duplicate_item_ids:
                        continue

                    if action == "ignore":
                        processed_count += 1
                        continue

                    for duplicate_item_id in duplicate_item_ids:
                        self.reassign_item_references(cursor, duplicate_item_id, anchor_item_id)

                    if suggested_name:
                        update_name_sql = """
                            UPDATE items
                            SET name = CASE
                                WHEN name ? 'ru' AND name ? 'en' THEN
                                    jsonb_set(
                                        jsonb_set(name, '{ru}', to_jsonb(%s::text)),
                                        '{en}',
                                        to_jsonb(%s::text)
                                    )
                                WHEN name ? 'ru' THEN
                                    jsonb_set(
                                        jsonb_set(name, '{ru}', to_jsonb(%s::text)),
                                        '{en}',
                                        to_jsonb(%s::text),
                                        true
                                    )
                                WHEN name ? 'en' THEN
                                    jsonb_set(name, '{en}', to_jsonb(%s::text))
                                ELSE
                                    jsonb_build_object('en', %s::text)
                            END
                            WHERE id = %s
                            AND "deletedAt" IS NULL
                        """
                        cursor.execute(
                            update_name_sql,
                            (
                                suggested_name,
                                suggested_name,
                                suggested_name,
                                suggested_name,
                                suggested_name,
                                suggested_name,
                                anchor_item_id,
                            ),
                        )

                        update_vector_sql = """
                            UPDATE vector_data
                            SET identifier = %s
                            WHERE item_id = %s
                        """
                        cursor.execute(update_vector_sql, (suggested_name, anchor_item_id))

                    archive_and_delete_sql = """
                        WITH moved_rows AS (
                            DELETE FROM items
                            WHERE id = %s
                            AND "deletedAt" IS NULL
                            RETURNING *
                        )
                        INSERT INTO items_archive
                        SELECT *
                        FROM moved_rows
                    """
                    for duplicate_item_id in duplicate_item_ids:
                        cursor.execute(archive_and_delete_sql, (duplicate_item_id,))
                        if cursor.rowcount > 0:
                            vector_delete_sql = """
                                DELETE FROM vector_data
                                WHERE item_id = %s
                            """
                            cursor.execute(vector_delete_sql, (duplicate_item_id,))

                    processed_count += 1
                    continue

                item_one_id = pair.get("item_one_id")
                item_two_id = pair.get("item_two_id")
                title_one = pair.get("title_one")
                title_two = pair.get("title_two")
                suggested_name = pair.get("suggested_name") or pair.get("suggest_name")
                action = pair.get("action", "merge")

                if item_one_id is None or item_two_id is None or not title_one or not title_two:
                    continue

                if action == "ignore":
                    processed_count += 1
                    continue

                self.reassign_item_references(cursor, item_two_id, item_one_id)

                if suggested_name:
                    update_name_sql = """
                        UPDATE items
                        SET name = CASE
                            WHEN name ? 'ru' AND name ? 'en' THEN
                                jsonb_set(
                                    jsonb_set(name, '{ru}', to_jsonb(%s::text)),
                                    '{en}',
                                    to_jsonb(%s::text)
                                )
                            WHEN name ? 'ru' THEN
                                jsonb_set(
                                    jsonb_set(name, '{ru}', to_jsonb(%s::text)),
                                    '{en}',
                                    to_jsonb(%s::text),
                                    true
                                )
                            WHEN name ? 'en' THEN
                                jsonb_set(name, '{en}', to_jsonb(%s::text))
                            ELSE
                                jsonb_build_object('en', %s::text)
                        END
                        WHERE id = %s
                        AND "deletedAt" IS NULL
                    """
                    cursor.execute(
                        update_name_sql,
                        (
                            suggested_name,
                            suggested_name,
                            suggested_name,
                            suggested_name,
                            suggested_name,
                            suggested_name,
                            item_one_id,
                        ),
                    )

                    update_vector_sql = """
                        UPDATE vector_data
                        SET identifier = %s
                        WHERE item_id = %s
                    """
                    cursor.execute(update_vector_sql, (suggested_name, item_one_id))

                archive_and_delete_sql = """
                    WITH moved_rows AS (
                        DELETE FROM items
                        WHERE id = %s
                        AND "deletedAt" IS NULL
                        RETURNING *
                    )
                    INSERT INTO items_archive
                    SELECT *
                    FROM moved_rows
                """
                cursor.execute(archive_and_delete_sql, (item_two_id,))

                if cursor.rowcount > 0:
                    vector_delete_sql = """
                        DELETE FROM vector_data
                        WHERE item_id = %s
                    """
                    cursor.execute(vector_delete_sql, (item_two_id,))
                    processed_count += 1

            conn.commit()

        return processed_count
