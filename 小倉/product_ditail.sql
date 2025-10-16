-- ======================================================================
-- 商品テーブル定義（参考用）
-- 注意: このテーブルはcreate_all_tables.sqlでProductsとして定義済み
-- ======================================================================

USE Hoppy_DB;

-- Products テーブル(create_all_tables.sqlで定義済みのため、このファイルは参考用)
-- 実際のテーブル名は Products (大文字P)
-- CREATE TABLE IF NOT EXISTS Products (
--     product_id CHAR(32) NOT NULL PRIMARY KEY,
--     products_name VARCHAR(255) NOT NULL,
--     shipping_limit_at DATETIME,
--     rental_price INT NOT NULL,
--     public_id INT NOT NULL,
--     user_id CHAR(36) NOT NULL,
--     tag_id CHAR(32),
--     genre_id CHAR(32),
--     product_explanation VARCHAR(500),
--     FOREIGN KEY (public_id) REFERENCES public_master(public_id),
--     FOREIGN KEY (user_id) REFERENCES user_accounts(user_id),
--     FOREIGN KEY (tag_id) REFERENCES Tag(tag_id),
--     FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
-- );
