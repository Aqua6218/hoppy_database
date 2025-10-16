-- ======================================================================
-- Hoppy Database - 統合テーブル作成スクリプト
-- 作成日: 2025年10月16日
-- 説明: すべてのテーブルを作成するための統合SQLファイル
-- ======================================================================

-- データベースの作成と使用
CREATE DATABASE IF NOT EXISTS Hoppy_DB;
USE Hoppy_DB;

-- ======================================================================
-- セクション 1: ユーザーアカウント関連テーブル
-- ======================================================================

-- user_accounts: ユーザーアカウント情報
CREATE TABLE user_accounts (
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (UUID形式を推奨)',
    nickname VARCHAR(20) NOT NULL UNIQUE COMMENT 'ニックネーム',
    email VARCHAR(254) NOT NULL UNIQUE COMMENT 'メールアドレス',
    password_hash VARCHAR(100) NOT NULL COMMENT 'パスワードハッシュ',
    full_name VARCHAR(20) NOT NULL COMMENT '氏名',
    full_name_kana VARCHAR(40) NOT NULL COMMENT 'カナ氏名',
    address VARCHAR(255) COMMENT '住所',
    postal_code CHAR(7) COMMENT '郵便番号 (ハイフンなし7桁)',
    phone_number CHAR(11) COMMENT '電話番号 (最大11桁)',
    birth_date CHAR(8) COMMENT '生年月日 (YYYYMMDD形式を推奨)',
    gender TINYINT(1) COMMENT '性別 (例: 0=男性, 1=女性)',
    login_attempt_count INT NOT NULL DEFAULT 0 COMMENT 'ログイン試行回数',
    profile_text VARCHAR(500) COMMENT '自己紹介文',
    icon_image_url VARCHAR(512) COMMENT 'アイコン画像URL',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'アカウント作成日時'
);

-- terms_of_service_master: 利用規約マスタ
CREATE TABLE terms_of_service_master (
    terms_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '利用規約ID',
    terms_version VARCHAR(10) NOT NULL COMMENT '利用規約バージョン番号 (例: 1.0.0)',
    terms_content VARCHAR(3000) NOT NULL COMMENT '利用規約の内容 (テキスト本文)',
    effective_date CHAR(10) NOT NULL COMMENT '施行日 (YYYY-MM-DD形式を推奨)'
);

-- acceptance_of_terms_of_use: 利用規約同意履歴
CREATE TABLE acceptance_of_terms_of_use (
    consent_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '利用規約同意ID',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    terms_id CHAR(32) NOT NULL COMMENT '利用規約ID (外部キー: terms_of_service_master.terms_id)',
    consent_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '規約同意日時',
    is_consented BOOLEAN NOT NULL DEFAULT TRUE COMMENT '同意フラグ (1=同意, 0=未同意/撤回)',
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (terms_id) REFERENCES terms_of_service_master(terms_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- account_status_master: アカウントステータスマスタ
CREATE TABLE account_status_master (
    account_status_id INT NOT NULL PRIMARY KEY COMMENT 'ステータスID',
    account_status_name VARCHAR(20) NOT NULL UNIQUE COMMENT 'アカウントステータス名 (例: アクティブ, 凍結, 削除済み)'
);

-- account_status: アカウントステータス履歴
CREATE TABLE account_status (
    status_log_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'ステータス変更履歴ID',
    account_status_id INT NOT NULL COMMENT 'ステータスID (外部キー: account_status_master.account_status_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    effective_from DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ステータス適用開始日時',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (account_status_id) REFERENCES account_status_master(account_status_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- user_mypage: ユーザーマイページ
CREATE TABLE user_mypage (
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    announcement_id INT COMMENT 'お知らせID',
    transaction_id CHAR(36) COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- two_factor_auth: 二段階認証設定
CREATE TABLE two_factor_auth (
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    user_two_factor BOOLEAN NOT NULL DEFAULT FALSE COMMENT '二段階認証設定 (1=ON, 0=OFF)',
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- notification_settings: 通知設定
CREATE TABLE notification_settings (
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    is_notification_enabled BOOLEAN NOT NULL DEFAULT TRUE COMMENT '通知設定 (1=ON, 0=OFF)',
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- login: ログイン履歴
CREATE TABLE login (
    last_login_at DATETIME NOT NULL COMMENT 'ログイン日時情報',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    device TEXT COMMENT 'ログイン端末情報',
    ip_address VARCHAR(128) COMMENT 'IPアドレス',
    country_code VARCHAR(100) COMMENT 'ログイン位置情報',
    is_success BOOLEAN COMMENT 'ログイン試行の成否フラグ',

    PRIMARY KEY (user_id, last_login_at),
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- logout: ログアウト履歴
CREATE TABLE logout (
    last_logout_at DATETIME NOT NULL COMMENT 'ログアウト日時情報',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    PRIMARY KEY (user_id, last_logout_at),
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Account_delete: アカウント削除履歴
CREATE TABLE Account_delete (
    deleted_at DATETIME NOT NULL COMMENT 'アカウント削除日時',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    no_active_products BOOLEAN NOT NULL COMMENT '削除時の出品中商品の有無 (1=なし, 0=あり)',
    last_transaction_completed DATETIME COMMENT '最終取引完了日時',

    PRIMARY KEY (user_id, deleted_at),
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Application_for_restoration_Master: アカウント復旧ステータスマスタ
CREATE TABLE Application_for_restoration_Master (
    restoration_id INT NOT NULL PRIMARY KEY COMMENT '復旧ステータスID',
    restoration_name VARCHAR(20) NOT NULL UNIQUE COMMENT 'ステータス状況名'
);

-- Application_for_restoration: アカウント復旧申請
CREATE TABLE Application_for_restoration (
    application_for_restoration_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '復旧申請ID',
    restoration_text VARCHAR(500) COMMENT '申請内容',
    restoration_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申請日時',
    restoration_id INT NOT NULL COMMENT '復旧ステータスID (外部キー: Application_for_restoration_Master.restoration_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    FOREIGN KEY (restoration_id) REFERENCES Application_for_restoration_Master(restoration_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Personal_information: 本人確認情報
CREATE TABLE Personal_information (
    personal_information_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '本人情報ID',
    application_for_restoration_id CHAR(32) NOT NULL COMMENT '復旧申請ID (外部キー: Application_for_restoration.application_for_restoration_id)',
    personal_information_address VARCHAR(254) NOT NULL COMMENT '対象メールアドレス',
    personal_information_call_num VARCHAR(11) COMMENT '対象電話番号',
    personal_information_hashpass VARCHAR(100) NOT NULL COMMENT '対称パスワード (ハッシュ)',
    personal_information_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提出日時',

    FOREIGN KEY (application_for_restoration_id) REFERENCES Application_for_restoration(application_for_restoration_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ======================================================================
-- セクション 2: 商品・取引関連テーブル
-- ======================================================================

-- public_master: 公開状態マスタ
CREATE TABLE public_master (
    public_id INT NOT NULL PRIMARY KEY COMMENT '公開状態ID',
    public_name VARCHAR(20) NOT NULL UNIQUE COMMENT '公開状態名 (例: 公開, 非公開, 一時停止済み)'
);

-- Tag: タグマスタ
CREATE TABLE Tag (
    tag_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'タグID',
    tag_text VARCHAR(10) NOT NULL UNIQUE COMMENT 'タグ内容'
);

-- Genre: ジャンルマスタ
CREATE TABLE Genre (
    genre_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'ジャンルID',
    genre_text VARCHAR(10) NOT NULL UNIQUE COMMENT 'ジャンル内容'
);

-- Products: 商品情報
CREATE TABLE Products (
    product_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '商品ID',
    products_name VARCHAR(255) NOT NULL COMMENT '商品名',
    shipping_limit_at DATETIME COMMENT '発送期限',
    rental_price INT NOT NULL COMMENT 'レンタル価格',
    public_id INT NOT NULL COMMENT '公開状態ID (外部キー: public_master.public_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    tag_id CHAR(32) COMMENT 'タグID (外部キー: Tag.tag_id)',
    genre_id CHAR(32) COMMENT 'ジャンルID (外部キー: Genre.genre_id)',
    product_explanation VARCHAR(500) COMMENT '商品説明',

    FOREIGN KEY (public_id) REFERENCES public_master(public_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- product_like: 商品いいね
CREATE TABLE product_like (
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    PRIMARY KEY (product_id, user_id),

    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- transaction_status_master: 取引ステータスマスタ
CREATE TABLE transaction_status_master (
    transaction_status_id INT NOT NULL PRIMARY KEY COMMENT '取引ステータスID',
    transaction_status_name VARCHAR(20) NOT NULL UNIQUE COMMENT '取引ステータス名'
);

-- transaction_type_master: 取引種別マスタ
CREATE TABLE transaction_type_master (
    transaction_type_id INT NOT NULL PRIMARY KEY COMMENT '取引種別ID',
    transaction_type_name VARCHAR(20) NOT NULL UNIQUE COMMENT '取引種別名'
);

-- guarantee_master: 保証マスタ
CREATE TABLE guarantee_master (
    guarantee_id INT NOT NULL PRIMARY KEY COMMENT '保証ID',
    guarantee_type_name VARCHAR(50) NOT NULL UNIQUE COMMENT '保証種別名'
);

-- transaction: 取引情報
CREATE TABLE transaction (
    transaction_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '取引ID',
    seller_id CHAR(36) NOT NULL COMMENT '出品者ID (外部キー: user_accounts.user_id)',
    buyer_id CHAR(36) NOT NULL COMMENT '購入者ID (外部キー: user_accounts.user_id)',
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    transaction_status_id INT NOT NULL COMMENT '取引ステータスID (外部キー: transaction_status_master.transaction_status_id)',
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '取引開始日時',
    completed_at DATETIME COMMENT '取引完了日時',
    shipped_at DATETIME COMMENT '配送期限',
    returned_at DATETIME COMMENT '返却日時',
    is_warranty_service BOOLEAN DEFAULT FALSE COMMENT '保証サービスプラン (TRUE/FALSE)',
    transaction_type_id INT NOT NULL COMMENT '取引種別ID (外部キー: transaction_type_master.transaction_type_id)',

    FOREIGN KEY (seller_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (buyer_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (transaction_status_id) REFERENCES transaction_status_master(transaction_status_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (transaction_type_id) REFERENCES transaction_type_master(transaction_type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- total_sales: 売上管理
CREATE TABLE total_sales (
    total_sales_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '売上ID',
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    sales_amount VARCHAR(1000) NOT NULL COMMENT '売上金額',
    fee VARCHAR(100) NOT NULL COMMENT '手数料',
    is_paid_out BOOLEAN NOT NULL DEFAULT FALSE COMMENT '出金状態 (1=出金済み, 0=未出金)',
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    
    UNIQUE KEY uk_sales_transaction (transaction_id, user_id)
);

-- evaluation: 評価情報
CREATE TABLE evaluation (
    evaluation_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '評価ID',
    transaction_id CHAR(36) NOT NULL UNIQUE COMMENT '取引ID (外部キー: transaction.transaction_id)',
    comment VARCHAR(500) COMMENT '評価コメント',
    seller_id CHAR(36) NOT NULL COMMENT '被評価者ユーザーID (外部キー: user_accounts.user_id)',
    buyer_id CHAR(36) NOT NULL COMMENT '評価者ユーザーID (外部キー: user_accounts.user_id)',
    evaluated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '評価日時',

    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (seller_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (buyer_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- purchase_permission: 購入許可
CREATE TABLE purchase_permission (
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    permission_granted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '許可日',
    is_allowed BOOLEAN NOT NULL COMMENT '購入許可フラグ (TRUE/FALSE)',

    PRIMARY KEY (transaction_id, user_id),
    
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- deal_penalties: ペナルティ管理
CREATE TABLE deal_penalties (
    penalty_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'ペナルティID',
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ペナルティ対象ユーザーID (外部キー: user_accounts.user_id)',
    delay_started_at DATETIME COMMENT '遅延開始日時',
    delayed_days INT COMMENT '遅延日数',
    extension_fee DECIMAL(18, 2) COMMENT '延滞料金',
    deduction_value DECIMAL(5, 2) COMMENT '評価減点',
    is_forced_purchase BOOLEAN NOT NULL COMMENT '強制購入フラグ (TRUE=強制購入適用)',
    forced_purchase_at DATETIME COMMENT '強制購入日時',
    additional_fee DECIMAL(18, 2) COMMENT '追加ペナルティ料金',
    payout_completed_at DATETIME COMMENT '最終支払い日時',

    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ======================================================================
-- セクション 3: コミュニティ関連テーブル
-- ======================================================================

-- Experience_posts: 体験投稿
CREATE TABLE Experience_posts (
    post_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '投稿ID (一意の識別子として自動生成)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    title VARCHAR(100) NOT NULL COMMENT 'タイトル (10文字以上100文字以下)',
    body TEXT NOT NULL COMMENT '投稿本文 (最大3000文字)',
    image_url JSON NULL COMMENT '画像URL (最大5枚まで)',
    video_url JSON NULL COMMENT '動画URL (1本まで)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Like_posts: 投稿いいね
CREATE TABLE Like_posts (
    like_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'いいねID',
    post_id CHAR(36) NOT NULL COMMENT '投稿ID (外部キー: Experience_posts.post_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    liked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'いいねがされた日時',

    UNIQUE KEY uk_post_user (post_id, user_id),
    
    FOREIGN KEY (post_id) REFERENCES Experience_posts(post_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Post_Delete_log: 投稿削除ログ
CREATE TABLE Post_Delete_log (
    log_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ログID (UUIDとして自動生成)',
    post_id CHAR(36) NOT NULL COMMENT '投稿ID (外部キー: Experience_posts.post_id)',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    deletion_reason VARCHAR(255) NULL COMMENT '削除理由',
    deleted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '投稿が削除された日時',

    FOREIGN KEY (post_id) REFERENCES Experience_posts(post_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Question_posts: 質問投稿
CREATE TABLE Question_posts (
    question_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '質問識別ID',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    title VARCHAR(100) NOT NULL COMMENT '質問のタイトル',
    body TEXT NOT NULL COMMENT '質問本文 (最大1000文字)',
    category_id INT NOT NULL COMMENT 'カテゴリID (関連カテゴリID)',
    tag VARCHAR(50) NULL COMMENT 'タグ',
    status VARCHAR(20) NOT NULL COMMENT '状態 (例: open, answered, closedなど)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Answer_posts: 回答投稿
CREATE TABLE Answer_posts (
    answer_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '回答ID',
    question_id CHAR(36) NOT NULL COMMENT '質問ID (外部キー: Question_posts.question_id)',
    user_id CHAR(36) NOT NULL COMMENT '回答ユーザーID (外部キー: user_accounts.user_id)',
    body VARCHAR(800) NOT NULL COMMENT '回答本文 (最大800文字)',
    is_best_answer BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'ベストアンサーかどうかを示すフラグ',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    FOREIGN KEY (question_id) REFERENCES Question_posts(question_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Notification: 通知
CREATE TABLE Notification (
    notification_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '通知ID',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    notification_type VARCHAR(50) NOT NULL COMMENT '通知タイプ',
    source_id CHAR(36) NOT NULL COMMENT '通知元ID',
    body VARCHAR(500) NOT NULL COMMENT '通知内容',
    is_read BOOLEAN NOT NULL DEFAULT FALSE COMMENT '既読フラグ',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Follow: フォロー関係
CREATE TABLE Follow (
    follow_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'フォローID',
    following_user_id CHAR(36) NOT NULL COMMENT 'フォローしているユーザーID (外部キー: user_accounts.user_id)',
    followed_user_id CHAR(36) NOT NULL COMMENT 'フォローされているユーザーID (外部キー: user_accounts.user_id)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    UNIQUE KEY uk_follow (following_user_id, followed_user_id),
    
    FOREIGN KEY (following_user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (followed_user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ======================================================================
-- セクション 4: サポート関連テーブル
-- ======================================================================

-- Contact: お問い合わせ
CREATE TABLE Contact (
    inquiry_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'お問い合わせID',
    user_id CHAR(36) NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    email VARCHAR(255) NOT NULL COMMENT '問い合わせ元メールアドレス',
    category VARCHAR(50) NOT NULL COMMENT '問い合わせカテゴリ',
    subject VARCHAR(50) NOT NULL COMMENT '件名',
    body TEXT NOT NULL COMMENT '問い合わせ本文 (最大1200文字)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    status VARCHAR(50) NOT NULL COMMENT '対応状況',
    responder_id CHAR(36) NULL COMMENT '対応した運営担当者のID',
    reply_content TEXT NULL COMMENT '運営担当者からの返信内容',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- FAQ: よくある質問
CREATE TABLE FAQ (
    faq_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'Q&A ID',
    category VARCHAR(100) NOT NULL COMMENT '質問のカテゴリ',
    question TEXT NOT NULL COMMENT '質問内容',
    answer TEXT NOT NULL COMMENT '回答内容'
);

-- Mannual_content: マニュアルコンテンツ
CREATE TABLE Mannual_content (
    content_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'コンテンツID',
    content_type VARCHAR(36) NOT NULL COMMENT 'コンテンツ種別',
    title VARCHAR(255) NOT NULL COMMENT 'コンテンツのタイトル',
    body TEXT NOT NULL COMMENT 'コンテンツ本文 (最大3000文字)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時',

    UNIQUE KEY uk_content (content_type, title)
);

-- Notice: お知らせ
CREATE TABLE Notice (
    notice_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'お知らせID',
    type VARCHAR(50) NOT NULL COMMENT 'お知らせの種別',
    title VARCHAR(255) NOT NULL COMMENT 'お知らせのタイトル',
    body TEXT NOT NULL COMMENT 'お知らせの本文 (最大3000文字)',
    start_time DATETIME NOT NULL COMMENT '通知の表示開始日時',
    end_time DATETIME NULL COMMENT '通知の表示終了日時',
    status VARCHAR(20) NOT NULL COMMENT 'お知らせの現在のステータス'
);

-- ======================================================================
-- セクション 5: 決済関連テーブル
-- ======================================================================

-- payment_method_Master: 支払方法マスタ
CREATE TABLE payment_method_Master (
    payment_method_id INT NOT NULL PRIMARY KEY COMMENT '支払方法ID',
    payment_method_name VARCHAR(20) NOT NULL COMMENT '支払方法名'
);

-- payment_method: 支払方法
CREATE TABLE payment_method (
    payment_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '支払ID',
    transaction_id CHAR(36) NOT NULL UNIQUE COMMENT '取引ID (外部キー: transaction.transaction_id)',
    payment_method_id INT NOT NULL COMMENT '支払方法ID (外部キー: payment_method_Master.payment_method_id)',
    cardholder_name VARCHAR(100) NOT NULL COMMENT '名義人',
    payment_number VARCHAR(50) NOT NULL COMMENT '支払情報番号',
    payment_hashpass VARCHAR(100) NOT NULL COMMENT '支払情報ハッシュパス',
    payment_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支払日時',

    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (payment_method_id) REFERENCES payment_method_Master(payment_method_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ======================================================================
-- セクション 6: その他テーブル
-- ======================================================================

-- reports_Master: 通報ジャンルマスタ
CREATE TABLE reports_Master (
    report_Genre_ID INT NOT NULL PRIMARY KEY COMMENT '通報ジャンルID',
    report_Genre_name VARCHAR(20) NOT NULL COMMENT '通報ジャンル名'
);

-- incident_reports: インシデント報告
CREATE TABLE incident_reports (
    incident_reports_ID CHAR(32) NOT NULL PRIMARY KEY COMMENT '報告ID',
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    incident_reports_TEXT VARCHAR(500) NOT NULL COMMENT '報告内容詳細',
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',

    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ======================================================================
-- 完了メッセージ (Hoppy_DB)
-- ======================================================================
-- Hoppy_DBのテーブル作成が完了しました

-- ======================================================================
-- セクション 7: 管理者データベース (セキュリティ分離)
-- ======================================================================

-- 管理者用データベースの作成と使用
CREATE DATABASE IF NOT EXISTS admin_DB;
USE admin_DB;

-- admin_users: 管理者ユーザー
CREATE TABLE admin_users (
    admin_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '管理者ID',
    admin_first_name VARCHAR(10) COMMENT '名',
    admin_last_name VARCHAR(10) COMMENT '姓',
    admin_birthday DATE COMMENT '生年月日',
    admin_mail VARCHAR(255) COMMENT 'メールアドレス'
);

-- admin_authorities: 管理者権限
CREATE TABLE admin_authorities (
    admin_permission_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '権限ID',
    admin_id INT NOT NULL COMMENT '管理者ID (外部キー: admin_users.admin_id)',
    admin_user_post_perms INT DEFAULT 0 COMMENT 'ユーザー投稿管理権限 (0=なし, 1=あり)',
    admin_inquiry_perms INT DEFAULT 0 COMMENT 'お問い合わせ管理権限 (0=なし, 1=あり)',
    admin_contract_type_perms INT DEFAULT 0 COMMENT '契約タイプ管理権限 (0=なし, 1=あり)',
    admin_admin_users INT DEFAULT 0 COMMENT '管理者ユーザー管理権限 (0=なし, 1=あり)',
    
    FOREIGN KEY (admin_id) REFERENCES admin_users(admin_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ======================================================================
-- 完了メッセージ
-- ======================================================================
-- すべてのテーブルの作成が完了しました
-- データベース: Hoppy_DB (メインデータベース)
-- データベース: admin_DB (管理者データベース - セキュリティ分離)