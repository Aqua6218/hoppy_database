
CREATE TABLE Experience_posts (
    -- 1. post_id (投稿ID) - 主キー
    post_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '投稿ID (一意の識別子として自動生成)',
    
    -- 2. user_id (ユーザーID) - 外部キー (user_accountsを参照)
    -- VARCHAR(16)だがCHAR(36)に統一
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. title (タイトル)
    title VARCHAR(100) NOT NULL COMMENT 'タイトル (10文字以上100文字以下)',
    
    -- 4. body (本文)
    -- TEXT型を使用し、最大3000文字の制限はアプリケーション側で制御
    body TEXT NOT NULL COMMENT '投稿本文 (最大3000文字)',
    
    -- 5. image_url (画像URL)
    -- 複数URLを格納するためJSON型を採用
    image_url JSON NULL COMMENT '画像URL (最大5枚まで)',
    
    -- 6. video_url (動画URL)
    -- 1本まで動画を格納するためJSON型を採用 (単一URLでもJSONで扱う)
    video_url JSON NULL COMMENT '動画URL (1本まで)',
    
    -- 7. created_at (作成日時)
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Like_posts (
    -- 1. like_id (いいねID) - 主キー
    like_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'いいねID',
    
    -- 2. post_id (投稿ID) - 外部キー (Experience_postsを参照)
    post_id CHAR(36) NOT NULL COMMENT '投稿ID (外部キー: Experience_posts.post_id)',
    
    -- 3. user_id (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. liked_at (いいね日時)
    liked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'いいねがされた日時',

    -- 制約: 1ユーザーは1投稿に1回だけ「いいね」できる
    UNIQUE KEY uk_post_user (post_id, user_id),
    
    -- 外部キー制約の定義
    FOREIGN KEY (post_id) REFERENCES Experience_posts(post_id)
        ON UPDATE CASCADE ON DELETE CASCADE, -- 投稿が削除されたら「いいね」も削除
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Post_Delete_log (
    -- 1. log_id (ログID) - 主キー
    log_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'ログID (UUIDとして自動生成)',
    
    -- 2. post_id (投稿ID) - 外部キー (Experience_postsを参照)
    -- 画像定義はVARCHAR(16)だがCHAR(36)に統一
    post_id CHAR(36) NOT NULL COMMENT '投稿ID (外部キー: Experience_posts.post_id)',
    
    -- 3. user_id (ユーザーID) - 外部キー (user_accountsを参照)
    -- 画像定義はVARCHAR(16)だがCHAR(36)に統一
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. deletion_reason (削除理由)
    deletion_reason VARCHAR(255) NULL COMMENT '削除理由 (例: ユーザーによるキャンセル、規約違反など)',
    
    -- 5. deleted_at (削除日時)
    deleted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '投稿が削除された日時',

    -- 外部キー制約の定義
    FOREIGN KEY (post_id) REFERENCES Experience_posts(post_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Question_posts (
    -- 1. question_id (質問識別ID) - 主キー
    question_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '質問識別ID',
    
    -- 2. user_id (ユーザーID) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. title (質問のタイトル)
    title VARCHAR(100) NOT NULL COMMENT '質問のタイトル',
    
    -- 4. body (質問本文)
    body TEXT NOT NULL COMMENT '質問本文 (最大1000文字)',
    
    -- 5. category (カテゴリID)
    category_id INT NOT NULL COMMENT 'カテゴリID (関連カテゴリID)',
    
    -- 6. tag (タグ) - ENUMの代わりにVARCHARで対応
    tag VARCHAR(50) NULL COMMENT 'タグ (ENUM: 例: technical, pricingなど)',
    
    -- 7. status (状態) - ENUMの代わりにVARCHARで対応
    status VARCHAR(20) NOT NULL COMMENT '状態 (ENUM: 例: open, answered, closedなど)',
    
    -- 8. created_at (作成日時)
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Answer_posts (
    -- 1. answer_id (回答ID) - 主キー
    answer_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '回答ID',
    
    -- 2. question_id (質問ID) - 外部キー (Question_postsを参照)
    -- 画像定義はVARCHAR(16)だがCHAR(36)に統一
    question_id CHAR(36) NOT NULL COMMENT '質問ID (外部キー: Question_posts.question_id)',
    
    -- 3. user_id (回答ユーザー) - 外部キー (user_accountsを参照)
    user_id CHAR(36) NOT NULL COMMENT '回答ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. body (回答本文)
    body VARCHAR(800) NOT NULL COMMENT '回答本文 (最大800文字)',
    
    -- 5. is_best_answer (ベストアンサーフラグ)
    is_best_answer BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'ベストアンサーかどうかを示すフラグ (TRUE/FALSE)',
    
    -- 6. created_at (作成日時)
    -- TIME型ではなくDATETIME型に修正
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    -- 制約: 1つの質問と1つのユーザーの組み合わせでユニークである必要はないが、質問ごとに複数の回答を許可する。

    -- 外部キー制約の定義
    FOREIGN KEY (question_id) REFERENCES Question_posts(question_id)
        ON UPDATE CASCADE ON DELETE CASCADE, -- 質問が削除されたら回答も削除
        
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Notification (
    -- 1. notification_id (通知ID) - 主キー
    notification_id CHAR(36) NOT NULL PRIMARY KEY COMMENT '通知ID',
    
    -- 2. user_id (ユーザーID) - 外部キー (user_accountsを参照)
    -- 画像定義はVARCHAR(16)だがCHAR(36)に統一
    user_id CHAR(36) NOT NULL COMMENT 'ユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. notification_type (通知タイプ)
    notification_type VARCHAR(50) NOT NULL COMMENT '通知タイプ (例: transaction_update, system_alert, post_reply)',
    
    -- 4. source_id (通知元ID)
    source_id CHAR(36) NOT NULL COMMENT '通知元ID (例: Transaction_ID, Item_ID, Post_IDなど、遷移先特定に使用)',
    
    -- 5. Body (通知内容)
    body VARCHAR(500) NOT NULL COMMENT '通知内容',
    
    -- 6. Is_Read (既読フラグ)
    is_read BOOLEAN NOT NULL DEFAULT FALSE COMMENT '既読フラグ (FALSE/0: 未読, TRUE/1: 既読)',
    
    -- 7. created_at (作成日時)
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    -- 外部キー制約の定義
    FOREIGN KEY (user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE -- ユーザーが削除されたら通知も削除
);


CREATE TABLE Follow (
    -- 1. follow_id (フォローID) - 主キー
    follow_id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'フォローID',
    
    -- 2. following_user_id (フォローしているユーザーID) - 外部キー (user_accountsを参照)
    following_user_id CHAR(36) NOT NULL COMMENT 'フォローしているユーザーID (外部キー: user_accounts.user_id)',
    
    -- 3. followed_user_id (フォローされているユーザーID) - 外部キー (user_accountsを参照)
    followed_user_id CHAR(36) NOT NULL COMMENT 'フォローされているユーザーID (外部キー: user_accounts.user_id)',
    
    -- 4. created_at (作成日時)
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

    -- 制約: 同じユーザー同士のフォロー関係が重複しないようにする
    UNIQUE KEY uk_follow (following_user_id, followed_user_id),
    
    -- 外部キー制約の定義
    FOREIGN KEY (following_user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE, -- フォローしているユーザーが削除されたら関連レコードも削除
        
    FOREIGN KEY (followed_user_id) REFERENCES user_accounts(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE -- フォローされているユーザーが削除されたら関連レコードも削除
);
