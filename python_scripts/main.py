# Точка входа: загрузка данных за один день
import sys
from datetime import date, timedelta

from api_client import fetch_data
from data_processor import process_data
from db import insert_sales
from logger import get_logger

log = get_logger(__name__)


def get_target_date():
    # Если дата передана аргументом, то берём её
    if len(sys.argv) > 1:
        return sys.argv[1]

    # Иначе - вчера
    yesterday = date.today() - timedelta(days=1)
    return yesterday.isoformat()


def main():
    target_date = get_target_date()
    log.info(f'Старт загрузки за {target_date}')

    data = fetch_data(target_date)
    if data is None:
        log.error(f'Не удалось получить данные за {target_date}')
        return 

    clean = process_data(data)
    if not clean:
        log.warning(f'Нет валидных записей за {target_date}')
        return

    inserted = insert_sales(clean)
    log.info(f'загрузка за {target_date} завершена: {inserted} записей')


if __name__ == '__main__':
    main()