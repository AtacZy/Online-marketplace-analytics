# Читаем переменные окружения из .env
import os
from dotenv import load_dotenv

# Загружаем .env из корня проекта
load_dotenv()

# Подключение к Postgres
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", 5432))
POSTGRES_DB = os.getenv("POSTGRES_DB", "marketplace")
POSTGRES_USER = os.getenv("POSTGRES_USER", "analyst")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")

# API маркетплейса
API_URL = os.getenv("API_URL", "http://final-project.simulative.ru/data")