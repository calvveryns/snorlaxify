import json
import logging
from contextlib import contextmanager
from typing import Any, Dict, List, Optional
from enum import Enum

import psycopg2
from psycopg2.extras import Json

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
    def get_identifiers(self) -> List[str]:
        with self.get_cursor() as (cursor, conn):
            cursor.execute("""
                           SELECT (name::json->>'en') AS name
                           FROM items
                           WHERE "typeId" = 7
                             AND "deletedAt" IS NULL
                           """)
            rows = cursor.fetchall()
            return [row[0] for row in rows]

    def setup_vector_extension(self):
        with self.get_cursor() as (cursor, conn):
            cursor.execute("CREATE EXTENSION IF NOT EXISTS vector;")
            conn.commit()

    def create_vector_table(self):
        create_table_sql = """
        CREATE TABLE IF NOT EXISTS vector_data (
            id SERIAL PRIMARY KEY,
            identifier TEXT UNIQUE NOT NULL,
            vector vector(768) NOT NULL
        )
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(create_table_sql)
            conn.commit()

    def insert_or_update_vector(self, identifier: str, vector: List[float]):
        insert_sql = """
            INSERT INTO vector_data (identifier, vector)
            VALUES (%s, %s)
            ON CONFLICT (identifier) DO UPDATE
            SET vector = EXCLUDED.vector
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(insert_sql, (identifier, vector))
            conn.commit()

    def get_close_pairs(self) -> List[Dict[str, float]]:
        query_sql = """
            SELECT
                item_one.identifier AS title_one,
                item_two.identifier AS title_two,
                item_one.vector <=> item_two.vector AS distance
            FROM vector_data item_one
            JOIN vector_data item_two ON item_one.id < item_two.id
            WHERE item_one.vector <=> item_two.vector <= 0.15
            ORDER BY distance;
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(query_sql)
            rows = cursor.fetchall()
            return [
                {"title_one": row[0], "title_two": row[1], "distance": float(row[2])}
                for row in rows
            ]

    def create_pipeline_tables(self):
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
            error: Optional[str] = None
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

    @staticmethod
    def _to_json_payload(recommendations: Any) -> Any:
        if recommendations is None:
            return None
        if isinstance(recommendations, (dict, list)):
            return recommendations
        if isinstance(recommendations, str):
            try:
                return json.loads(recommendations)
            except json.JSONDecodeError:
                return {"message": recommendations}
        return {"value": recommendations}

    def save_pipeline_result(self, task_id: str, recommendations: Any, error: Optional[str] = None):
        payload = self._to_json_payload(recommendations)
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
                    return row[0]
                return None
        except Exception as e:
            logger.error(f"Error getting pipeline result for task {task_id}: {e}")
            return None
