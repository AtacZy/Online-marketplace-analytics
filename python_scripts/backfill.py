# Загрузка исторических данных с 2022-01-01 по вчера
import sys
from datetime import date, timedelta

from api_client import fetch_data
from data_processor import process_data
from db import get_connection, insert_sales
from logger import get_logger

log = get_logger(__name__)

# Самая ранняя дата, с которой API отдаёт данные
START_DATE = date(2022, 1, 1)


def get_loaded_dates():
    # Возвращает множество дат, уже загруженных в БД
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT purchase_datetime FROM raw.sales")
            return {row[0] for row in cur.fetchall()}


def date_range(start, end):
    # Генератор дат от start до end включительно
    current = start
    while current <= end:
        yield current
        current += timedelta(days=1)


def backfill(start_date, end_date):
    # Загружает данные за все даты в диапазоне
    loaded = get_loaded_dates()
    log.info(f'Уже загружено дат: {len(loaded)}')

    all_dates = list(date_range(start_date, end_date))
    to_load = [d for d in all_dates if d not in loaded]

    log.info(f'Всего дат в диапазоне: {len(all_dates)}')
    log.info(f'К загрузке: {len(to_load)}')

    if not to_load:
        log.info('Все даты уже загружены')
        return

    total_inserted = 0
    total_errors = 0

    for i, target_date in enumerate(to_load, 1):
        date_str = target_date.isoformat()

        try:
            data = fetch_data(date_str)
            if data is None:
                log.error(f'[{i}/{len(to_load)}] {date_str}: ошибка API')
                total_errors += 1
                continue

            clean = process_data(data)
            if not clean:
                log.warning(f'[{i}/{len(to_load)}] {date_str}: нет данных')
                continue

            inserted = insert_sales(clean)
            total_inserted += inserted
            log.info(f'[{i}/{len(to_load)}] {date_str}: {inserted} записей')

        except Exception as e:
            log.error(f'[{i}/{len(to_load)}] {date_str}: {e}')
            total_errors += 1

    log.info(f'Backfill завершён: {total_inserted} записей, ошибок: {total_errors}')


def get_args():
    # Парсит аргументы: python backfill.py [start] [end]
    start = START_DATE
    end = date.today() - timedelta(days=1)

    if len(sys.argv) > 1:
        start = date.fromisoformat(sys.argv[1])
    if len(sys.argv) > 2:
        end = date.fromisoformat(sys.argv[2])

    return start, end


if __name__ == "__main__":
    start, end = get_args()
    log.info(f"Backfill: {start} -> {end}")
    backfill(start, end)