import logging
from contextlib import contextmanager
from typing import List, Dict

import psycopg2

logger = logging.getLogger(__name__)


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
                SELECT identifier
                FROM items
                WHERE "typeIdentifier" = 'item'
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
            WHERE item_one.vector <=> item_two.vector <= 0.35
            ORDER BY distance;
        """
        with self.get_cursor() as (cursor, conn):
            cursor.execute(query_sql)
            rows = cursor.fetchall()
            return [
                {"title_one": row[0], "title_two": row[1], "distance": float(row[2])}
                for row in rows
            ]

    def commit_all_changes(self):
        with self.get_connection() as conn:
            conn.commit()
