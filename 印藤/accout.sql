
CREATE TABLE user_accounts (
    -- 14. user_ID (ユーザーID) - UUIDを想定した主キー
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (UUID形式を推奨)',
    
    -- 1. nickname (ニックネーム) - 必須、一意
    nickname VARCHAR(20) NOT NULL UNIQUE COMMENT 'ニックネーム',
    
    -- 2. email (メールアドレス) - 必須、一意
    email VARCHAR(254) NOT NULL UNIQUE COMMENT 'メールアドレス',
    
    -- 3. password_hash (パスワードハッシュ) - 必須 (生のパスワードではなくハッシュを格納)
    password_hash VARCHAR(100) NOT NULL COMMENT 'パスワードハッシュ',
    
    -- 7. full_name (氏名) - 必須 (本人確認や配送のために必須を推奨)
    full_name VARCHAR(20) NOT NULL COMMENT '氏名',
    
    -- 8. full_name_kana (カナ氏名) - 必須
    full_name_kana VARCHAR(40) NOT NULL COMMENT 'カナ氏名',
    
    -- 4. address (住所) - 任意
    address VARCHAR(255) COMMENT '住所',
    
    -- 5. postal_code (郵便番号) - 任意 (固定長7桁)
    postal_code CHAR(7) COMMENT '郵便番号 (ハイフンなし7桁)',
    
    -- 6. phone_number (電話番号) - 任意 (固定電話・携帯電話10桁or11桁を想定)
    phone_number CHAR(11) COMMENT '電話番号 (最大11桁)',
    
    -- 9. birth_date (生年月日) - 任意 (例: 19900101)
    birth_date CHAR(8) COMMENT '生年月日 (YYYYMMDD形式を推奨)',
    
    -- 10. gender (性別) - 任意 (0:男性, 1:女性, NULL:未設定など)
    gender TINYINT(1) COMMENT '性別 (例: 0=男性, 1=女性)',
    
    -- 11. login_attempt_count (ログイン試行回数) - 必須、デフォルト0 (アカウントロック機能などに利用)
    login_attempt_count INT NOT NULL DEFAULT 0 COMMENT 'ログイン試行回数',
    
    -- 17. profile_text (自己紹介) - 任意
    profile_text VARCHAR(500) COMMENT '自己紹介文',
    
    -- 18. icon_image_url (アイコン画像URL) - 任意
    icon_image_url VARCHAR(512) COMMENT 'アイコン画像URL',
    
    -- 15. created_at (アカウント作成日時) - 必須、自動記録
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'アカウント作成日時'
);

CREATE TABLE terms_of_service_master (
    -- 1. terms_ID (利用規約ID) - 主キー
    terms_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '利用規約ID',
    
    -- 2. terms_version (利用規約バージョン番号)
    terms_version VARCHAR(10) NOT NULL COMMENT '利用規約バージョン番号 (例: 1.0.0)',
    
    -- 6. Terms of use contents (利用規約の内容)
    -- カラム名をSQLの慣例に合わせて terms_content としました
    terms_content VARCHAR(3000) NOT NULL COMMENT '利用規約の内容 (テキスト本文)',
    
    -- 7. terms_day (施行日)
    -- カラム名をSQLの慣例に合わせて effective_date としました
    effective_date CHAR(10) NOT NULL COMMENT '施行日 (YYYY-MM-DD形式を推奨。日付型が望ましい)'
);

CREATE TABLE acceptance_of_terms_of_use (
    -- 1. consent_ID (利用規約同意ID) - 主キー
    consent_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '利用規約同意ID',
    
    -- 2. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 6. terms_ID (利用規約ID) - 外部キー (terms_of_service_masterを参照)
    terms_id CHAR(32) NOT NULL COMMENT '利用規約ID (外部キー: terms_of_service_master.terms_id)',
    
    -- 7. Consent Datetime (規約同意日時)
    consent_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '規約同意日時',
    
    -- 8. is_consented (同意フラグ) - BOOLEAN型を推奨 (1: 同意, 0: 未同意または撤回)
    is_consented BOOLEAN NOT NULL DEFAULT TRUE COMMENT '同意フラグ (1=同意, 0=未同意/撤回)',
    
    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, -- ユーザーが削除されたら同意情報も削除
    
    FOREIGN KEY (terms_id) REFERENCES terms_of_service_master(terms_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- 利用規約マスタレコードは削除不可
);

CREATE TABLE account_status_master (
    -- 1. Account_status_ID (ステータスID) - 主キー (INT型、長さは適切な範囲のINTに)
    account_status_id INT NOT NULL PRIMARY KEY COMMENT 'ステータスID',
    
    -- 2. Account_status_name (アカウントステータス)
    account_status_name VARCHAR(20) NOT NULL UNIQUE COMMENT 'アカウントステータス名 (例: アクティブ, 凍結, 削除済み)'
);


CREATE TABLE account_status (
    -- トランザクションレコードを一意に識別するための主キー
    status_log_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'ステータス変更履歴ID',
    
    -- 1. Account_status_ID (ステータスID) - 外部キー (account_status_masterを参照)
    -- 注意: 項目定義のNo.1とNo.3が重複しているため、ここでは status_log_idを主キーとし、この項目は外部キーとして定義します。
    account_status_id INT NOT NULL COMMENT 'ステータスID (外部キー: account_status_master.account_status_id)',
    
    -- 2. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- ステータス適用開始日時 (履歴管理のため追加)
    effective_from DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ステータス適用開始日時',

    -- 外部キー制約の定義
    -- user_accountsテーブルが存在することを前提とします
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, -- ユーザーが削除されたらステータス履歴も削除
    
    -- account_status_masterテーブルが存在することを前提とします
    FOREIGN KEY (account_status_id) REFERENCES account_status_master(account_status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- ステータスマスタレコードは削除不可
);

CREATE TABLE user_mypage (
    -- 1. user_ID (ユーザーID) - 主キーかつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    
    -- 2. announcement_id (お知らせID) - お知らせテーブルとの連携を想定
    announcement_id INT COMMENT 'お知らせID',
    
    -- 6. transaction_id (取引ID) - 外部キー (取引管理テーブルを参照)
    transaction_id CHAR(36) COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    -- transaction_idの外部キー設定は、transactionsテーブル作成後に定義してください
    -- FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


CREATE TABLE two_factor_auth (
    -- 1. user_ID (ユーザーID) - 主キーかつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    
    -- 2. user_two_factor (二段階認証設定) - BOOLEAN型 (TRUE=ON, FALSE=OFF)
    user_two_factor BOOLEAN NOT NULL DEFAULT FALSE COMMENT '二段階認証設定 (1=ON, 0=OFF)',
    
    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE notification (
    -- 1. user_ID (ユーザーID) - 主キーかつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ユーザーID (主キー・外部キー: user_accounts.user_id)',
    
    -- 2. notification (通知設定) - BOOLEAN型 (TRUE=ON, FALSE=OFF)
    notification BOOLEAN NOT NULL DEFAULT TRUE COMMENT '通知設定 (1=ON, 0=OFF)',
    
    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE total_sales (
    -- 1. total_sales_ID (売り上げID) - 主キー
    total_sales_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '売上ID',
    
    -- 2. transaction_id (取引ID) - 外部キー (取引管理テーブルを参照)
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    -- 3. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. sales_amount (売上金額) - ※計算のためDECIMAL/INT型を強く推奨しますが、指示に従いVARCHAR
    sales_amount VARCHAR(1000) NOT NULL COMMENT '売上金額',
    
    -- 5. fee (手数料) - ※計算のためDECIMAL/INT型を強く推奨しますが、指示に従いVARCHAR
    fee VARCHAR(100) NOT NULL COMMENT '手数料',
    
    -- 8. is_paid_out (出金状態) - BOOLEAN型 (TRUE=出金済み, FALSE=未出金)
    is_paid_out BOOLEAN NOT NULL DEFAULT FALSE COMMENT '出金状態 (1=出金済み, 0=未出金)',
    
    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    -- transaction_idの外部キー設定は、transactionsテーブル作成後に定義してください
    -- FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
    
    -- 売上IDと取引ID、ユーザーIDの組み合わせがユニークであることを想定
    UNIQUE KEY uk_sales_transaction (transaction_id, user_id)
);


CREATE TABLE login (
    -- 主キー: ログイン処理のログを一意に識別するID。user_IDとlast_login_atの組み合わせでもユニークだが、
    -- 複数のログイン試行があるため、ここでは複合主キーまたはサロゲートキーを採用する。
    -- 画像の定義にないため、ここでは複合キーとして定義する。
    
    -- 1. last_login_at (ログイン日時情報)
    last_login_at DATETIME NOT NULL COMMENT 'ログイン日時情報',
    
    -- 2. user_ID (ユーザーID) - 主キーの一部かつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    -- 3. device (ログイン端末情報)
    device TEXT COMMENT 'ログイン端末情報',
    
    -- 4. IP_address (IPアドレス)
    ip_address VARCHAR(128) COMMENT 'IPアドレス',
    
    -- 5. country_code (ログイン位置情報)
    country_code VARCHAR(100) COMMENT 'ログイン位置情報',
    
    -- 6. is_success (成功フラグ)
    is_success BOOLEAN COMMENT 'ログイン試行の成否フラグ',

    -- user_idとlast_login_atの組み合わせを主キーとします。
    PRIMARY KEY (user_id, last_login_at),

    -- 外部キー制約の定義
    -- user_accountsテーブルが存在することを前提とします (Hoppy_DB内のuser_accountsを指す想定)
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE -- ユーザーが削除されたらログイン履歴も削除
);


CREATE TABLE logout (
    -- 1. last_logout_at (ログアウト日時情報) - 複合主キーの一部
    last_logout_at DATETIME NOT NULL COMMENT 'ログアウト日時情報',
    
    -- 2. user_ID (ユーザーID) - 複合主キーの一部かつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    -- user_idとlast_logout_atの組み合わせを主キーとします。
    PRIMARY KEY (user_id, last_logout_at),

    -- 外部キー制約の定義
    -- user_accountsテーブルが存在することを前提とします
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE -- ユーザーが削除されたらログアウト履歴も削除
);

CREATE TABLE Account_delete (
    -- 1. deleted_at (アカウント削除日時) - 複合主キーの一部
    deleted_at DATETIME NOT NULL COMMENT 'アカウント削除日時',
    
    -- 2. user_ID (ユーザーID) - 複合主キーの一部かつ外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    -- 3. no_active_products (出品中商品の有無) - boolean (TRUE=なし, FALSE=あり)
    -- 備考の「出品中商品の有無」を元に、boolean型をNOT NULLで定義
    no_active_products BOOLEAN NOT NULL COMMENT '削除時の出品中商品の有無 (1=なし, 0=あり)',
    
    -- 4. last_transaction_completed (最終取引完了日時) - 備考の「取引完了から一週間後」を考慮し、最終取引が完了した日時を記録
    last_transaction_completed DATETIME COMMENT '最終取引完了日時',

    -- user_idとdeleted_atの組み合わせを主キーとします。
    PRIMARY KEY (user_id, deleted_at),

    -- 外部キー制約の定義
    -- user_accountsテーブルが存在することを前提とします
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- ユーザーアカウントは論理削除（ステータス変更）が原則のため、履歴は残す
);

CREATE TABLE Application_for_restoration_Master (
    -- 1. restoration_ID (復旧ステータスID) - 主キー
    restoration_id INT NOT NULL PRIMARY KEY COMMENT '復旧ステータスID',
    
    -- 2. restoration_name (ステータス状況名) - 例: 本人確認待ち, 審査中, 承認済み
    restoration_name VARCHAR(20) NOT NULL UNIQUE COMMENT 'ステータス状況名'
);


CREATE TABLE Application_for_restoration (
    -- 1. Application_for_restoration_ID (復旧申請ID) - 主キー
    application_for_restoration_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '復旧申請ID',
    
    -- 2. restoration_TEXT (申請内容)
    restoration_text VARCHAR(500) COMMENT '申請内容',
    
    -- 3. restoration_at (申請日時)
    restoration_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申請日時',
    
    -- 4. restoration_ID (復旧ステータスID) - 外部キー (復旧申請マスタを参照)
    restoration_id INT NOT NULL COMMENT '復旧ステータスID (外部キー: Application_for_restoration_Master.restoration_id)',
    
    -- 5. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    -- 外部キー制約の定義
    FOREIGN KEY (restoration_id) REFERENCES Application_for_restoration_Master(restoration_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, 
    
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE -- ユーザーが削除されたら申請履歴も削除
);

CREATE TABLE Personal_information (
    -- 1. Personal_information_ID (本人情報ID) - 主キー
    personal_information_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '本人情報ID',
    
    -- 2. Application_for_restoration_ID (復旧申請ID) - 外部キー (アカウント復旧申請を参照)
    -- 画像では主キーとされていますが、外部キーとして定義
    application_for_restoration_id CHAR(32) NOT NULL COMMENT '復旧申請ID (外部キー: Application_for_restoration.application_for_restoration_id)',
    
    -- 3. Personal_information_address (対象メールアドレス)
    personal_information_address VARCHAR(254) NOT NULL COMMENT '対象メールアドレス',
    
    -- 4. Personal_information_callNum (対象電話番号)
    personal_information_call_num VARCHAR(11) COMMENT '対象電話番号', -- 電話番号は必須ではない場合があるためNULL許可
    
    -- 5. Personal_information_hashpass (対称パスワード(ハッシュ))
    personal_information_hashpass VARCHAR(100) NOT NULL COMMENT '対称パスワード (ハッシュ)',
    
    -- 6. Personal_information_at (提出日時)
    personal_information_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提出日時',

    -- 外部キー制約の定義
    FOREIGN KEY (application_for_restoration_id) REFERENCES Application_for_restoration(application_for_restoration_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- 申請が残っている限り、本人確認情報も残す
);

CREATE TABLE Products (
    -- 1. product_ID (商品ID) - 主キー
    product_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '商品ID',
    
    -- 2. products_name (商品名)
    products_name VARCHAR(255) NOT NULL COMMENT '商品名',
    
    -- 3. shipping_limit_at (発送期限)
    shipping_limit_at DATETIME COMMENT '発送期限',
    
    -- 4. rental_price (レンタル価格) - INT型が適切ですが、画像指示通りINTで作成
    rental_price INT NOT NULL COMMENT 'レンタル価格',
    
    -- 5. public_id (公開状態ID) - 外部キー (public_masterを参照)
    public_id INT NOT NULL COMMENT '公開状態ID (外部キー: public_master.public_id)',
    
    -- 6. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 7. tag_ID (タグID) - 外部キー (Tagを参照)
    tag_id CHAR(32) COMMENT 'タグID (外部キー: Tag.tag_id)',
    
    -- 8. genre_ID (ジャンルID) - 外部キー (Genreを参照)
    genre_id CHAR(32) COMMENT 'ジャンルID (外部キー: Genre.genre_id)',
    
    -- 9. product_explanation (商品説明) - 画像にはないが、実用上重要なので追加
    product_explanation VARCHAR(500) COMMENT '商品説明',

    -- 外部キー制約の定義
    FOREIGN KEY (public_id) REFERENCES public_master(public_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, -- 出品者がいる限り商品は残る
        
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);


CREATE TABLE transaction (
    -- 1. transaction_ID (取引ID) - 主キー
    transaction_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '取引ID',
    
    -- 2. seller_ID (出品者ID) - 外部キー (user_accountsを参照)
    seller_id CHAR(36) NOT NULL COMMENT '出品者ID (外部キー: user_accounts.user_id)',
    
    -- 3. buyer_ID (購入者ID) - 外部キー (user_accountsを参照)
    buyer_id CHAR(36) NOT NULL COMMENT '購入者ID (外部キー: user_accounts.user_id)',
    
    -- 4. product_ID (商品ID) - 外部キー (Productsを参照)
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    
    -- 5. transaction_status_ID (取引ステータスID) - 外部キー (transaction_status_masterを参照)
    transaction_status_id INT NOT NULL COMMENT '取引ステータスID (外部キー: transaction_status_master.transaction_status_id)',
    
    -- 6. started_at (取引開始日時)
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '取引開始日時',
    
    -- 7. completed_at (取引完了日時)
    completed_at DATETIME COMMENT '取引完了日時',
    
    -- 8. shipped_at (配送期限)
    shipped_at DATETIME COMMENT '配送期限',
    
    -- 9. returned_at (返却日時) - レンタル取引の場合
    returned_at DATETIME COMMENT '返却日時',
    
    -- 10. is_warranty_service (保証サービスプラン)
    is_warranty_service BOOLEAN DEFAULT FALSE COMMENT '保証サービスプラン (TRUE/FALSE)',
    
    -- 11. transaction_type_ID (取引種別ID) - 外部キー (transaction_type_masterを参照)
    transaction_type_id INT NOT NULL COMMENT '取引種別ID (外部キー: transaction_type_master.transaction_type_id)',

    -- 外部キー制約の定義
    FOREIGN KEY (seller_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    FOREIGN KEY (buyer_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    FOREIGN KEY (transaction_status_id) REFERENCES transaction_status_master(transaction_status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    FOREIGN KEY (transaction_type_id) REFERENCES transaction_type_master(transaction_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE transaction_status_master (
    -- 1. transaction_status_ID (取引ステータスID) - 主キー
    transaction_status_id INT NOT NULL PRIMARY KEY COMMENT '取引ステータスID',
    
    -- 2. transaction_status_name (取引ステータス名) - 例: 配送待ち、使用中、返却待ち、評価待ち
    transaction_status_name VARCHAR(20) NOT NULL UNIQUE COMMENT '取引ステータス名'
);



CREATE TABLE transaction_type_master (
    -- 1. transaction_type_ID (取引種別ID) - 主キー
    transaction_type_id INT NOT NULL PRIMARY KEY COMMENT '取引種別ID',
    
    -- 2. transaction_type_name (取引種別名) - 例: レンタル、購入
    transaction_type_name VARCHAR(20) NOT NULL UNIQUE COMMENT '取引種別名'
);


CREATE TABLE guarantee_master (
    -- 1. guarantee_ID (保証ID) - 主キー
    guarantee_id INT NOT NULL PRIMARY KEY COMMENT '保証ID',
    
    -- 2. guarantee_type_name (保証種別名) - 例: スタンダードプラン、ライトプラン、なし
    guarantee_type_name VARCHAR(50) NOT NULL UNIQUE COMMENT '保証種別名'
);


CREATE TABLE product_like (
    -- 1. product_ID (商品ID) - 複合主キーの一部
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    
    -- 2. user_ID (ユーザーID) - 複合主キーの一部
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 複合主キー
    PRIMARY KEY (product_id, user_id),

    -- 外部キー制約の定義
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Tag (
    -- 1. tag_ID (タグID) - 主キー
    tag_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'タグID',
    
    -- 2. tag_TEXT (タグ内容)
    tag_text VARCHAR(10) NOT NULL UNIQUE COMMENT 'タグ内容'
);


CREATE TABLE Genre (
    -- 1. Genre_ID (ジャンルID) - 主キー
    genre_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'ジャンルID',
    
    -- 2. Genre_TEXT (ジャンル内容)
    genre_text VARCHAR(10) NOT NULL UNIQUE COMMENT 'ジャンル内容'
);


CREATE TABLE evaluation (
    -- 1. evaluation_id (評価ID) - 主キー
    evaluation_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '評価ID',
    
    -- 2. transaction_id (取引ID) - 外部キー (transactionを参照)
    -- UNIQUE制約により、一つの取引に対して評価は一度のみを保証
    transaction_id CHAR(36) NOT NULL UNIQUE COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    -- 3. comment (評価コメント)
    comment VARCHAR(500) COMMENT '評価コメント', -- NULL許可 (コメントは任意)

    -- 4. seller_id (被評価者ユーザーID - この取引での出品者/レンタル者) - 外部キー (user_accountsを参照)
    seller_id CHAR(36) NOT NULL COMMENT '被評価者ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 5. buyer_id (評価者ユーザーID - この取引での購入者/利用者) - 外部キー (user_accountsを参照)
    buyer_id CHAR(36) NOT NULL COMMENT '評価者ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 6. evaluated_at (評価日時) - 評価がいつ行われたかを記録
    evaluated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '評価日時',

    -- 外部キー制約の定義
    -- transactionテーブルが存在することを前提
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    -- 被評価者(seller/出品者)
    FOREIGN KEY (seller_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    -- 評価者(buyer/購入者)
    FOREIGN KEY (buyer_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE purchase_permission (
    -- 2. transaction_id (取引ID) - 複合主キーの一部、外部キー (transactionを参照)
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    -- 3. user_id (ユーザーID) - 複合主キーの一部、外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',

    -- 複合主キーの定義 (どの取引にどのユーザーが許可されているかを一意に特定)
    PRIMARY KEY (transaction_id, user_id),
    
    -- 4. permission_granted_at (許可日)
    permission_granted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '許可日',
    
    -- 5. is_allowed (購入許可フラグ)
    is_allowed BOOLEAN NOT NULL COMMENT '購入許可フラグ (TRUE/FALSE)',

    -- 外部キー制約の定義
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE public_master (
    -- 1. public_id (公開状態ID) - 主キー
    public_id INT NOT NULL PRIMARY KEY COMMENT '公開状態ID',
    
    -- 2. public_name (公開状態名)
    public_name VARCHAR(20) NOT NULL UNIQUE COMMENT '公開状態名 (例: 公開, 非公開, 一時停止済み)'
);

CREATE TABLE deal_penalties (
    -- 1. penalty_ID (ペナルティID) - 主キー
    penalty_id CHAR(32) NOT NULL PRIMARY KEY COMMENT 'ペナルティID',
    
    -- 2. product_ID (商品ID) - 外部キー (Productsを参照)
    product_id CHAR(32) NOT NULL COMMENT '商品ID (外部キー: Products.product_id)',
    
    -- 3. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ペナルティ対象ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. delay_started_at (遅延開始日時)
    delay_started_at DATETIME COMMENT '遅延開始日時',
    
    -- 5. delayed_days (遅延日数)
    delayed_days INT COMMENT '遅延日数',
    
    -- 6. extension_fee (延滞料金)
    extension_fee DECIMAL(18, 2) COMMENT '延滞料金',
    
    -- 7. deduction_value (評価減点)
    deduction_value DECIMAL(5, 2) COMMENT '評価減点 (例: 1.5, 3.0)',
    
    -- 8. is_forced_purchase (強制購入フラグ)
    is_forced_purchase BOOLEAN NOT NULL COMMENT '強制購入フラグ (TRUE=強制購入適用)',
    
    -- 9. forced_purchase_at (強制購入日時)
    forced_purchase_at DATETIME COMMENT '強制購入日時',
    
    -- 10. additional_fee (追加ペナルティ料金)
    additional_fee DECIMAL(18, 2) COMMENT '追加ペナルティ料金',
    
    -- 11. payout_completed_at (最終支払い日時)
    payout_completed_at DATETIME COMMENT '最終支払い日時',

    -- 外部キー制約の定義
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE reports_Master (
    -- 1. report_Genre_ID (通報ジャンルID) - 主キー
    report_Genre_ID INT NOT NULL PRIMARY KEY COMMENT '通報ジャンルID',
    
    -- 2. report_Genre_name (通報ジャンル名)
    report_Genre_name VARCHAR(20) NOT NULL COMMENT '通報ジャンル名 (例: 商品, コミュニティ, アカウント)'
);

CREATE TABLE payment_method_Master (
    -- 1. payment_method_id (支払方法ID) - 主キー
    payment_method_id INT NOT NULL PRIMARY KEY COMMENT '支払方法ID',
    
    -- 2. payment_method_name (支払方法名)
    payment_method_name VARCHAR(20) NOT NULL COMMENT '支払方法名 (例: クレカ, 銀行引き落とし, PayPal)'
);

CREATE TABLE payment_method (
    -- 1. payment_ID (支払ID) - 主キー
    -- 定義書ではCHAR(5)だが、ユニーク性を考慮しCHAR(32)を採用（以前の定義に準拠）
    payment_id CHAR(32) NOT NULL PRIMARY KEY COMMENT '支払ID',
    
    -- 2. transaction_id (取引ID) - 外部キー (transactionを参照)
    -- 取引に対して支払いは通常1回なのでUNIQUE制約を追加
    transaction_id CHAR(36) NOT NULL UNIQUE COMMENT '取引ID (外部キー: transaction.transaction_id)',
    
    -- 3. payment_method_id (支払方法ID) - 外部キー (payment_method_Masterを参照)
    payment_method_id INT NOT NULL COMMENT '支払方法ID (外部キー: payment_method_Master.payment_method_id)',
    
    -- 4. cardholder_name (名義人)
    cardholder_name VARCHAR(100) NOT NULL COMMENT '名義人',
    
    -- 5. payment_number (支払情報番号)
    payment_number VARCHAR(50) NOT NULL COMMENT '支払情報番号 (例: クレジットカード下4桁など)',
    
    -- 6. payment_hashpass (支払情報ハッシュパス)
    payment_hashpass VARCHAR(100) NOT NULL COMMENT '支払情報ハッシュパス (機密情報のハッシュ)',
    
    -- 7. payment_at (支払日時)
    payment_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支払日時',

    -- 外部キー制約の定義
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    FOREIGN KEY (payment_method_id) REFERENCES payment_method_Master(payment_method_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE incident_reports (
    -- 1. incident_reports_ID (報告ID) - 主キー
    incident_reports_ID CHAR(32) NOT NULL PRIMARY KEY COMMENT '報告ID',
    
    -- 2. user_ID (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. incident_reports_TEXT (報告内容)
    incident_reports_TEXT VARCHAR(500) NOT NULL COMMENT '報告内容詳細',
    
    -- 4. transaction_id (取引ID) - 外部キー (transactionを参照)
    transaction_id CHAR(36) NOT NULL COMMENT '取引ID (外部キー: transaction.transaction_id)',

    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

