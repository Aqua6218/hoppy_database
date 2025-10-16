-- ======================================================================
-- admin_DB にサンプルデータを挿入
-- ======================================================================


-- admin_users テーブルのサンプルデータ
INSERT INTO admin_users (admin_first_name, admin_last_name, admin_birthday, admin_mail) VALUES
('太郎', '山田', '1990-05-15', 'yamada.taro@example.com'),
('花子', '鈴木', '1985-11-20', 'suzuki.hanako@example.com');

-- admin_authorities テーブルのサンプルデータ
INSERT INTO admin_authorities (admin_id, admin_user_post_perms, admin_inquiry_perms, admin_contract_type_perms, admin_admin_users) VALUES
(1, 1, 1, 1, 1),
(2, 1, 1, 0, 0);

-- user_accounts テーブルのサンプルデータ
INSERT INTO user_accounts (nickname, email, password, address, postal_code, phone_number, full_name, full_name_kana, birth_date, gender, login_count, user_id, created_at, profile_text, icon_image_url) VALUES
('テストユーザー1号', 'testuser1@example.com', 'hashed_password_1', '東京都港区', '1050001', '09012345678', '田中 健', 'タナカ ケン', '1992-03-01', 'M', 15, 'user_id_001', '2025-09-20', '初めまして！宜しくお願いします。', 'https://example.com/icons/user1.png'),
('ジェミニ', 'gemini@example.com', 'hashed_password_2', '神奈川県横浜市', '2200001', '08098765432', '佐藤 恵', 'サトウ メグミ', '1995-07-25', 'F', 5, 'user_id_002', '2025-09-22', '楽しく交流したいです。', 'https://example.com/icons/user2.png');

-- terms_of_service_master テーブルのサンプルデータ
INSERT INTO terms_of_service_master (terms_id, terms_version, terms_of_use_contents, terms_day) VALUES
('terms_001', '1.0.0', 'サービス利用規約の本文がここに記載されます。', '2025-09-01'),
('terms_002', '1.1.0', 'サービス利用規約の改訂版の本文がここに記載されます。', '2025-10-15');

-- Account_Status_Master テーブルのサンプルデータ
INSERT INTO Account_Status_Master (account_status_ID, account_status_name) VALUES
(1, 'アクティブ'),
(2, '一時停止'),
(3, '削除済み');

-- Account_Acceptance_of_Terms_of_Use テーブルのサンプルデータ
INSERT INTO Account_Acceptance_of_Terms_of_Use (consent_ID, user_ID, terms_id, Consent_Datetime, is_consented) VALUES
('consent_001', 'user_id_001', 'terms_001', '2025-09-20 10:00:00', 1),
('consent_002', 'user_id_002', 'terms_002', '2025-10-15 15:30:00', 1);

-- Account_Status テーブルのサンプルデータ
INSERT INTO Account_Status (account_status_ID, user_ID) VALUES
(1, 'user_id_001'),
(1, 'user_id_002');

-- fee_settings テーブルのサンプルデータ
INSERT INTO fee_settings (fee_id, fee_amount, fee_update_date) VALUES
(1, 500, '2025-09-20'),
(2, 600, '2025-10-01');

-- admin_notices テーブルのサンプルデータ
INSERT INTO admin_notices (announcement_id, delivery_datetime, created_at, delivery_target, announcement_title, announcement_content, image_path) VALUES
(1, 202510161500, '2025-10-16', NULL, 'システムメンテナンスのお知らせ', '以下の時間帯でシステムメンテナンスを実施します。', NULL),
(2, 202510201000, '2025-10-18', 1, '新機能追加のお知らせ', '新機能が追加されました。ぜひご利用ください。', 'https://example.com/images/new_feature.png');

-- warranty_service_overview テーブルのサンプルデータ
INSERT INTO warranty_service_overview (warranty_id, warranty_content, update_date_and_time) VALUES
(1, '本サービスは、ユーザーの安心安全な取引を保証します。', '2025-09-24 10:00:00');

-- maintenance_log テーブルのサンプルデータ
INSERT INTO maintenance_log (maintenance_id, maintenance_title, maintenance_start_time, maintenance_end_time, memo) VALUES
(1, '定期メンテナンス', '2025-09-25 02:00:00', '2025-09-25 04:00:00', 'データベースの最適化を実施しました。');

-- admin_settings テーブルのサンプルデータ
INSERT INTO admin_settings (admin_id, created_at, fee_settings_ID, fee_update_date) VALUES
(1, '2025-09-20', 1, '2025-09-20');

-- ======================================================================
-- hoppy_db にサンプルデータを挿入
-- ======================================================================

USE hoppy_db;

-- products テーブルのサンプルデータ
INSERT INTO products (products_id, products_owner_id, products_main_image_url, products_name, products_description, products_rental_price, products_purchase_price, products_condition_code, products_shipping_code, products_is_public, products_likes_count, products_created_at, products_updated_at) VALUES
('prod_001', 'user_id_001', 'https://example.com/products/001_main.jpg', 'アウトドア用テント', '4人用の広々としたテントです。', 3000, 25000, 1, 1, TRUE, 5, '2025-09-21 10:30:00', '2025-09-21 10:30:00'),
('prod_002', 'user_id_002', 'https://example.com/products/002_main.jpg', '一眼レフカメラ', '高画質で美しい写真が撮れます。', 5000, 80000, 2, 1, TRUE, 12, '2025-09-22 15:00:00', '2025-09-22 15:00:00');