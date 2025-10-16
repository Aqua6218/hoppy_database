-- ======================================================================
-- 管理者データベーステーブル定義
-- 注意: これらのテーブルはセキュリティ上、admin_DBに配置されます
-- create_all_tables.sqlに統合済み
-- ======================================================================

-- USE admin_DB;

-- CREATE TABLE for user account
CREATE TABLE admin_users (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_first_name VARCHAR(10),
    admin_last_name VARCHAR(10),
    admin_birthday DATE,
    admin_mail VARCHAR(255)
);

-- CREATE TABLE for admin_authorities
CREATE TABLE admin_authorities (
    admin_permission_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NOT NULL,
    admin_user_post_perms INT DEFAULT 0,
    admin_inquiry_perms INT DEFAULT 0,
    admin_contract_type_perms INT DEFAULT 0,
    admin_admin_users INT DEFAULT 0,
    FOREIGN KEY (admin_id) REFERENCES admin_users(admin_id)
);