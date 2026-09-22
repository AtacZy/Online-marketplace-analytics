# Клиент для запросов к API маркетплейса
import requests

from config import API_URL
from logger import get_logger

log = get_logger(__name__)


def fetch_data(date):
    # Забирает данные за один день
    url = f"{API_URL}?date={date}"
    log.info(f'Запрос к API: {url}')

    try:
        response = requests.get(url, timeout=60)
    except requests.exceptions.RequestException as e:
        log.error(f'Ошибка соединения с API: {e}')
        return None

    if response.status_code != 200:
        log.error(f'API вернул статус {response.status_code} за {date}')
        return None

    try:
        data = response.json()
    except ValueError as e:
        log.warning(f'не удалось распарсить JSON за {date}: {e}')
        return []

    if not isinstance(data, list):
        log.warning(f'Неожиданный формат данных за {date}: {type(data).__name__}')
        return []

    log.info(f'Получено {len(data)} записей за {date}')
    return data