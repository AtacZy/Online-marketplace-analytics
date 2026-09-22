# Валидация данных из API перед загрузкой в БД
from logger import get_logger

log = get_logger(__name__)


# Все поля, которые должны быть в каждой записи
REQUIRED_FIELDS = [
    "client_id",
    "gender",
    "purchase_datetime",
    "purchase_time_as_seconds_from_midnight",
    "product_id",
    "quantity",
    "price_per_item",
    "discount_per_item",
    "total_price",
]


# Проверяет одну запись - все ли поля на месте и нет ли аномалий
def is_valid(record):
    # Все поля есть нам нужные?
    for field in REQUIRED_FIELDS:
        if field not in record:
            return False

    # Аномалии
    if record["quantity"] < 0:
        return False
    if record["price_per_item"] < 0:
        return False
    if record["discount_per_item"] < 0:
        return False
    if record["discount_per_item"] > record["price_per_item"]:
        return False
    if record["gender"] not in ("M", "F"):
        return False

    return True

# Оставляет только валидные данные
def process_data(data):
    if not data or not isinstance(data, list):
        log.warning('Нет данных для обработки')
        return []

    valid = []
    for record in data:
        if is_valid(record):
            valid.append(record)

    dropped = len(data) - len(valid)
    log.info(f'Обработано {len(data)} записей, валидных {len(valid)}, отброшено {dropped}')

    return valid