-- Read-only пользователь для проверяющего.
-- Реальный пароль меняется вручную на сервере (не хранить в git).
CREATE USER user_ro WITH PASSWORD 'change_me';

GRANT CONNECT ON DATABASE marketplace TO user_ro;
GRANT USAGE ON SCHEMA raw TO user_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA raw TO user_ro;

-- Для будущих таблиц в схеме raw
ALTER DEFAULT PRIVILEGES IN SCHEMA raw GRANT SELECT ON TABLES TO user_ro;