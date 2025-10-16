CREATE TABLE Contact (
    -- 1. inquiry_id (お問い合わせID) - 主キー
    inquiry_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'お問い合わせID',
    
    -- 2. user_id (ユーザーID) - 外部キー (user_accountsを参照, ゲストユーザーの場合はNULL可)
    -- 画像定義はVARCHAR(16)だがCHAR(36)に統一
    user_id CHAR(36) NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. email (メールアドレス)
    email VARCHAR(255) NOT NULL COMMENT '問い合わせ元メールアドレス',
    
    -- 4. category (カテゴリ)
    category VARCHAR(50) NOT NULL COMMENT '問い合わせカテゴリ (例: アカウント、取引、通報)',
    
    -- 5. subject (件名)
    subject VARCHAR(50) NOT NULL COMMENT '件名',
    
    -- 6. body (本題/問い合わせ内容)
    body TEXT NOT NULL COMMENT '問い合わせ本文 (最大1200文字)',
    
    -- 7. created_at (作成日時)
    -- 長さ定義を削除し、DATETIME型で必須とする
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    
    -- 8. status (ステータス)
    status VARCHAR(50) NOT NULL COMMENT '対応状況 (例: 未対応, 対応中, 完了)',
    
    -- 9. responder_id (対応者ID)
    responder_id CHAR(36) NULL COMMENT '対応した運営担当者のID (未対応時はNULL)',
    
    -- 10. reply_content (返信内容)
    reply_content TEXT NULL COMMENT '運営担当者からの返信内容',

    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL -- ユーザーが削除されても問い合わせ内容は残し、user_idをNULLにする
);

CREATE TABLE FAQ (
    -- 1. faq_id (Q&A ID) - 主キー
    faq_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'Q&A ID',
    
    -- 2. category (カテゴリ)
    category VARCHAR(100) NOT NULL COMMENT '質問のカテゴリ',
    
    -- 3. question (質問)
    question TEXT NOT NULL COMMENT '質問内容',
    
    -- 4. answer (回答)
    answer TEXT NOT NULL COMMENT '回答内容'
);


CREATE TABLE Mannual_content (
    -- 1. content_id (コンテンツID) - 主キー
    content_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'コンテンツID',
    
    -- 2. content_type (コンテンツ種別)
    content_type VARCHAR(36) NOT NULL COMMENT 'コンテンツ種別 (例: 利用規約, プライバシーポリシー, FAQ, ガイドライン)',
    
    -- 3. title (タイトル)
    title VARCHAR(255) NOT NULL COMMENT 'コンテンツのタイトル',
    
    -- 4. body (本文)
    body TEXT NOT NULL COMMENT 'コンテンツ本文 (最大3000文字)',
    
    -- 5. created_at (作成日時)
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    
    -- 6. update_at (最終更新日時)
    update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時',

    -- 制約: コンテンツ種別とタイトルは一意であるべき
    UNIQUE KEY uk_content (content_type, title)
);


CREATE TABLE Notice (
    -- 1. Notice_id (お知らせID) - 主キー
    notice_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'お知らせID',
    
    -- 2. type (種別)
    type VARCHAR(50) NOT NULL COMMENT 'お知らせの種別',
    
    -- 3. title (タイトル)
    title VARCHAR(255) NOT NULL COMMENT 'お知らせのタイトル',
    
    -- 4. body (本文)
    body TEXT NOT NULL COMMENT 'お知らせの本文 (最大3000文字)',
    
    -- 5. start_time (開始日時)
    start_time DATETIME NOT NULL COMMENT '通知の表示開始日時',
    
    -- 6. end_time (終了日時)
    end_time DATETIME NULL COMMENT '通知の表示終了日時 (恒久的なお知らせの場合はNULL)',
    
    -- 7. status (ステータス)
    status VARCHAR(20) NOT NULL COMMENT 'お知らせの現在のステータス (例: 公開中, 終了済)'
);
