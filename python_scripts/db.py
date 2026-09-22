# Работа с Postgres: подключение и вставка записей
import psycopg2
from psycopg2.extras import execute_values

from config import (
    POSTGRES_HOST,
    POSTGRES_PORT,
    POSTGRES_DB,
    POSTGRES_USER,
    POSTGRES_PASSWORD,
)
from logger import get_logger

log = get_logger(__name__)


# SQL для вставки. %s - плейсхолдер для execute_values
INSERT_SQL = """
INSERT INTO raw.sales (
    client_id, gender, purchase_datetime,
    purchase_time_as_seconds_from_midnight, product_id,
    quantity, price_per_item, discount_per_item, total_price
) VALUES %s
ON CONFLICT (
    client_id, product_id, purchase_datetime,
    purchase_time_as_seconds_from_midnight
) DO NOTHING
"""

def get_connection():
    # Возвращает соединение с Postgres
    return psycopg2.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        dbname=POSTGRES_DB,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
    )

def insert_sales(records):
    # Вставляет записи в raw.sales. Возвращает количество вставленных
    if not records:
        log.warning("Нет записей для вставки")
        return 0

    # Собираем кортежи значений в том же порядке, что и колонки в INSERT
    values = []
    for r in records:
        values.append((
            r["client_id"],
            r["gender"],
            r["purchase_datetime"],
            r["purchase_time_as_seconds_from_midnight"],
            r["product_id"],
            r["quantity"],
            r["price_per_item"],
            r["discount_per_item"],
            r["total_price"],
        ))

    with get_connection() as conn:
        with conn.cursor() as cur:
            # Считаем, сколько было до
            cur.execute("SELECT COUNT(*) FROM raw.sales")
            before = cur.fetchone()[0]

            # Вставляем
            execute_values(cur, INSERT_SQL, values)

            # Считаем, сколько стало
            cur.execute("SELECT COUNT(*) FROM raw.sales")
            after = cur.fetchone()[0]

        conn.commit()

    inserted = after - before
    log.info(f"Вставлено записей: {inserted} из {len(records)}")
    return inserted