use Hoppy_DB
CREATE TABLE IF NOT EXISTS products (
    products_id VARCHAR(36) PRIMARY KEY,
    products_owner_id VARCHAR(36) NOT NULL,
    products_main_image_url VARCHAR(255) NOT NULL,
    products_name VARCHAR(255) NOT NULL,
    products_description TEXT NOT NULL,
    products_rental_price INT NOT NULL,
    products_purchase_price INT NOT NULL,
    products_condition_code TINYINT NOT NULL,
    products_shipping_code TINYINT NOT NULL,
    products_is_public BOOLEAN NOT NULL,
    products_likes_count INT NOT NULL,
    products_created_at DATETIME NOT NULL,
    products_updated_at DATETIME NOT NULL
);