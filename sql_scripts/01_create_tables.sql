-- Схема raw — для сырых данных
CREATE SCHEMA IF NOT EXISTS raw;

-- Таблица raw.sales
CREATE TABLE IF NOT EXISTS raw.sales (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    gender CHAR(1) NOT NULL,
    purchase_datetime DATE NOT NULL,
    purchase_time_as_seconds_from_midnight INTEGER NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    price_per_item BIGINT NOT NULL,
    discount_per_item BIGINT NOT NULL,
    total_price NUMERIC(15, 2) NOT NULL,
    loaded_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_sales UNIQUE (
        client_id,
        product_id,
        purchase_datetime,
        purchase_time_as_seconds_from_midnight
    ),
    CONSTRAINT chk_gender CHECK (gender IN ('M', 'F')),
    CONSTRAINT chk_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_price CHECK (price_per_item >= 0),
    CONSTRAINT chk_discount CHECK (discount_per_item >= 0),
    CONSTRAINT chk_discount_le_price CHECK (discount_per_item <= price_per_item)
);

CREATE INDEX idx_sales_client ON raw.sales (client_id);
CREATE INDEX idx_sales_product ON raw.sales (product_id);
CREATE INDEX idx_sales_date ON raw.sales (purchase_datetime);
CREATE INDEX idx_sales_client_product ON raw.sales (client_id, product_id);