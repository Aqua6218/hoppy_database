-- ======================================================================
-- Hoppy Database - サンプルデータ挿入スクリプト
-- 作成日: 2025年10月16日
-- 説明: 各テーブルに30件のサンプルデータを挿入
-- ======================================================================

USE Hoppy_DB;

-- ======================================================================
-- セクション 1: マスタデータの挿入
-- ======================================================================

-- account_status_master
INSERT INTO account_status_master (account_status_id, account_status_name) VALUES
(1, 'アクティブ'),
(2, '一時停止'),
(3, '凍結'),
(4, '削除済み');

-- public_master
INSERT INTO public_master (public_id, public_name) VALUES
(1, '公開'),
(2, '非公開'),
(3, '一時停止済み'),
(4, '削除済み');

-- transaction_status_master
INSERT INTO transaction_status_master (transaction_status_id, transaction_status_name) VALUES
(1, '取引開始'),
(2, '配送待ち'),
(3, '配送中'),
(4, '使用中'),
(5, '返却待ち'),
(6, '返却中'),
(7, '評価待ち'),
(8, '取引完了'),
(9, 'キャンセル');

-- transaction_type_master
INSERT INTO transaction_type_master (transaction_type_id, transaction_type_name) VALUES
(1, 'レンタル'),
(2, '購入');

-- guarantee_master
INSERT INTO guarantee_master (guarantee_id, guarantee_type_name) VALUES
(1, 'なし'),
(2, 'ライトプラン'),
(3, 'スタンダードプラン'),
(4, 'プレミアムプラン');

-- Application_for_restoration_Master
INSERT INTO Application_for_restoration_Master (restoration_id, restoration_name) VALUES
(1, '申請受付'),
(2, '本人確認待ち'),
(3, '審査中'),
(4, '承認済み'),
(5, '却下');

-- payment_method_Master
INSERT INTO payment_method_Master (payment_method_id, payment_method_name) VALUES
(1, 'クレジットカード'),
(2, '銀行振込'),
(3, 'PayPal'),
(4, 'コンビニ決済');

-- reports_Master
INSERT INTO reports_Master (report_Genre_ID, report_Genre_name) VALUES
(1, '商品'),
(2, 'コミュニティ'),
(3, 'アカウント'),
(4, '取引');

-- terms_of_service_master
INSERT INTO terms_of_service_master (terms_id, terms_version, terms_content, effective_date) VALUES
(UUID(), '1.0.0', '本サービスの利用規約第1版です。', '2024-01-01'),
(UUID(), '1.1.0', '本サービスの利用規約第1.1版です。改訂内容を含みます。', '2024-06-01'),
(UUID(), '2.0.0', '本サービスの利用規約第2版です。大幅な改訂を行いました。', '2025-01-01');

-- Tag
INSERT INTO Tag (tag_id, tag_text) VALUES
(UUID(), 'アウトドア'),
(UUID(), 'キャンプ'),
(UUID(), 'カメラ'),
(UUID(), 'スポーツ'),
(UUID(), '音楽'),
(UUID(), 'ファッション'),
(UUID(), '家電'),
(UUID(), 'ゲーム'),
(UUID(), 'DIY'),
(UUID(), '旅行');

-- Genre
INSERT INTO Genre (genre_id, genre_text) VALUES
(UUID(), 'レジャー'),
(UUID(), '電子機器'),
(UUID(), 'ファッション'),
(UUID(), 'スポーツ'),
(UUID(), '音楽'),
(UUID(), 'カメラ'),
(UUID(), 'アウトドア'),
(UUID(), 'ホビー'),
(UUID(), '生活家電'),
(UUID(), 'その他');

-- ======================================================================
-- セクション 2: ユーザーアカウントデータ (30件)
-- ======================================================================

INSERT INTO user_accounts (user_id, nickname, email, password_hash, full_name, full_name_kana, address, postal_code, phone_number, birth_date, gender, profile_text, icon_image_url) VALUES
(UUID(), 'user001', 'user001@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '山田太郎', 'ヤマダタロウ', '東京都渋谷区1-1-1', '1500001', '09012345001', '19900101', 0, 'アウトドア好きです！', 'https://example.com/icons/001.png'),
(UUID(), 'user002', 'user002@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '佐藤花子', 'サトウハナコ', '神奈川県横浜市2-2-2', '2200002', '09012345002', '19920215', 1, 'カメラが趣味です', 'https://example.com/icons/002.png'),
(UUID(), 'user003', 'user003@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '鈴木一郎', 'スズキイチロウ', '大阪府大阪市3-3-3', '5300003', '09012345003', '19880320', 0, 'キャンプ大好き！', 'https://example.com/icons/003.png'),
(UUID(), 'user004', 'user004@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '田中美咲', 'タナカミサキ', '愛知県名古屋市4-4-4', '4600004', '09012345004', '19950412', 1, 'ファッション好き', 'https://example.com/icons/004.png'),
(UUID(), 'user005', 'user005@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '伊藤健太', 'イトウケンタ', '福岡県福岡市5-5-5', '8100005', '09012345005', '19910505', 0, 'スポーツ全般', 'https://example.com/icons/005.png'),
(UUID(), 'user006', 'user006@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '渡辺由美', 'ワタナベユミ', '北海道札幌市6-6-6', '0600006', '09012345006', '19930618', 1, '音楽鑑賞が趣味', 'https://example.com/icons/006.png'),
(UUID(), 'user007', 'user007@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '山本翔太', 'ヤマモトショウタ', '宮城県仙台市7-7-7', '9800007', '09012345007', '19870722', 0, 'DIY好き', 'https://example.com/icons/007.png'),
(UUID(), 'user008', 'user008@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '中村彩香', 'ナカムラアヤカ', '広島県広島市8-8-8', '7300008', '09012345008', '19940825', 1, '旅行大好き', 'https://example.com/icons/008.png'),
(UUID(), 'user009', 'user009@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '小林大輔', 'コバヤシダイスケ', '京都府京都市9-9-9', '6000009', '09012345009', '19890930', 0, 'ゲーム好き', 'https://example.com/icons/009.png'),
(UUID(), 'user010', 'user010@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '加藤真理', 'カトウマリ', '兵庫県神戸市10-10-10', '6500010', '09012345010', '19961010', 1, 'アート鑑賞', 'https://example.com/icons/010.png'),
(UUID(), 'user011', 'user011@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '吉田修平', 'ヨシダシュウヘイ', '埼玉県さいたま市11-11-11', '3300011', '09012345011', '19850115', 0, '釣り好き', 'https://example.com/icons/011.png'),
(UUID(), 'user012', 'user012@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '清水優子', 'シミズユウコ', '千葉県千葉市12-12-12', '2600012', '09012345012', '19970220', 1, '料理が得意', 'https://example.com/icons/012.png'),
(UUID(), 'user013', 'user013@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '森田健一', 'モリタケンイチ', '静岡県静岡市13-13-13', '4200013', '09012345013', '19880328', 0, 'サイクリング', 'https://example.com/icons/013.png'),
(UUID(), 'user014', 'user014@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '池田麻衣', 'イケダマイ', '茨城県水戸市14-14-14', '3100014', '09012345014', '19920405', 1, '読書好き', 'https://example.com/icons/014.png'),
(UUID(), 'user015', 'user015@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '橋本大樹', 'ハシモトダイキ', '栃木県宇都宮市15-15-15', '3200015', '09012345015', '19910512', 0, '登山好き', 'https://example.com/icons/015.png'),
(UUID(), 'user016', 'user016@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '山崎春菜', 'ヤマザキハルナ', '群馬県前橋市16-16-16', '3710016', '09012345016', '19950618', 1, 'ヨガ愛好家', 'https://example.com/icons/016.png'),
(UUID(), 'user017', 'user017@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '石井隆太', 'イシイリュウタ', '長野県長野市17-17-17', '3800017', '09012345017', '19870722', 0, 'スキー好き', 'https://example.com/icons/017.png'),
(UUID(), 'user018', 'user018@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '前田美穂', 'マエダミホ', '新潟県新潟市18-18-18', '9500018', '09012345018', '19930828', 1, 'ダンス好き', 'https://example.com/icons/018.png'),
(UUID(), 'user019', 'user019@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '藤田浩二', 'フジタコウジ', '富山県富山市19-19-19', '9300019', '09012345019', '19891005', 0, 'ドライブ好き', 'https://example.com/icons/019.png'),
(UUID(), 'user020', 'user020@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '岡田紗希', 'オカダサキ', '石川県金沢市20-20-20', '9200020', '09012345020', '19961110', 1, '映画鑑賞', 'https://example.com/icons/020.png'),
(UUID(), 'user021', 'user021@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '長谷川誠', 'ハセガワマコト', '福井県福井市21-21-21', '9100021', '09012345021', '19840115', 0, '釣り愛好家', 'https://example.com/icons/021.png'),
(UUID(), 'user022', 'user022@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '村上絵里', 'ムラカミエリ', '山梨県甲府市22-22-22', '4000022', '09012345022', '19980220', 1, 'ガーデニング', 'https://example.com/icons/022.png'),
(UUID(), 'user023', 'user023@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '近藤雄介', 'コンドウユウスケ', '岐阜県岐阜市23-23-23', '5000023', '09012345023', '19900325', 0, 'バスケ好き', 'https://example.com/icons/023.png'),
(UUID(), 'user024', 'user024@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '後藤瞳', 'ゴトウヒトミ', '三重県津市24-24-24', '5140024', '09012345024', '19920430', 1, 'カフェ巡り', 'https://example.com/icons/024.png'),
(UUID(), 'user025', 'user025@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '青木貴之', 'アオキタカユキ', '滋賀県大津市25-25-25', '5200025', '09012345025', '19880608', 0, 'テニス好き', 'https://example.com/icons/025.png'),
(UUID(), 'user026', 'user026@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '西村千尋', 'ニシムラチヒロ', '奈良県奈良市26-26-26', '6300026', '09012345026', '19940712', 1, '写真撮影', 'https://example.com/icons/026.png'),
(UUID(), 'user027', 'user027@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '福田智也', 'フクダトモヤ', '和歌山県和歌山市27-27-27', '6400027', '09012345027', '19910818', 0, 'サーフィン', 'https://example.com/icons/027.png'),
(UUID(), 'user028', 'user028@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '太田沙織', 'オオタサオリ', '鳥取県鳥取市28-28-28', '6800028', '09012345028', '19950925', 1, '編み物好き', 'https://example.com/icons/028.png'),
(UUID(), 'user029', 'user029@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '松本拓海', 'マツモトタクミ', '島根県松江市29-29-29', '6900029', '09012345029', '19871030', 0, 'ボルダリング', 'https://example.com/icons/029.png'),
(UUID(), 'user030', 'user030@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '木村夏美', 'キムラナツミ', '岡山県岡山市30-30-30', '7000030', '09012345030', '19991205', 1, 'イラスト制作', 'https://example.com/icons/030.png');

-- ======================================================================
-- セクション 3: ユーザー関連データ
-- ======================================================================

-- acceptance_of_terms_of_use (各ユーザーが最新の規約に同意)
INSERT INTO acceptance_of_terms_of_use (consent_id, user_id, terms_id, is_consented)
SELECT 
    UUID(),
    user_id,
    (SELECT terms_id FROM terms_of_service_master ORDER BY effective_date DESC LIMIT 1),
    TRUE
FROM user_accounts
LIMIT 30;

-- account_status (全ユーザーをアクティブに設定)
INSERT INTO account_status (account_status_id, user_id)
SELECT 1, user_id FROM user_accounts LIMIT 30;

-- two_factor_auth
INSERT INTO two_factor_auth (user_id, user_two_factor)
SELECT user_id, (RAND() > 0.5) FROM user_accounts LIMIT 30;

-- notification
INSERT INTO notification (user_id, notification)
SELECT user_id, TRUE FROM user_accounts LIMIT 30;

-- user_mypage
INSERT INTO user_mypage (user_id)
SELECT user_id FROM user_accounts LIMIT 30;

-- ======================================================================
-- セクション 4: 商品データ (30件)
-- ======================================================================

INSERT INTO Products (product_id, products_name, rental_price, public_id, user_id, tag_id, genre_id, product_explanation, shipping_limit_at)
SELECT 
    UUID(),
    CONCAT('商品', LPAD(@row := @row + 1, 3, '0')),
    FLOOR(1000 + RAND() * 9000),
    FLOOR(1 + RAND() * 2),
    user_id,
    (SELECT tag_id FROM Tag ORDER BY RAND() LIMIT 1),
    (SELECT genre_id FROM Genre ORDER BY RAND() LIMIT 1),
    CONCAT('これは商品', @row, 'の説明です。高品質な商品をレンタルできます。'),
    DATE_ADD(NOW(), INTERVAL FLOOR(7 + RAND() * 23) DAY)
FROM user_accounts, (SELECT @row := 0) r
LIMIT 30;

-- ======================================================================
-- セクション 5: コミュニティデータ
-- ======================================================================

-- Experience_posts (30件)
INSERT INTO Experience_posts (post_id, user_id, title, body)
SELECT 
    UUID(),
    user_id,
    CONCAT('体験談', LPAD(@post_row := @post_row + 1, 3, '0'), ': 素晴らしいレンタル体験'),
    CONCAT('とても良い体験ができました。商品の品質も良く、満足しています。投稿番号', @post_row)
FROM user_accounts, (SELECT @post_row := 0) r
LIMIT 30;

-- Like_posts (各投稿に3-5件のいいね)
INSERT INTO Like_posts (like_id, post_id, user_id)
SELECT 
    UUID(),
    p.post_id,
    u.user_id
FROM Experience_posts p
CROSS JOIN (
    SELECT user_id FROM user_accounts ORDER BY RAND() LIMIT 5
) u
WHERE p.user_id != u.user_id
LIMIT 100;

-- Question_posts (30件)
INSERT INTO Question_posts (question_id, user_id, title, body, category_id, status)
SELECT 
    UUID(),
    user_id,
    CONCAT('質問', LPAD(@q_row := @q_row + 1, 3, '0'), ': 使い方について'),
    CONCAT('この商品の使い方を教えてください。質問番号', @q_row),
    FLOOR(1 + RAND() * 5),
    CASE WHEN RAND() > 0.5 THEN 'open' ELSE 'answered' END
FROM user_accounts, (SELECT @q_row := 0) r
LIMIT 30;

-- Answer_posts (各質問に1-3件の回答)
INSERT INTO Answer_posts (answer_id, question_id, user_id, body, is_best_answer)
SELECT 
    UUID(),
    q.question_id,
    u.user_id,
    CONCAT('回答: こちらが使い方の説明です。'),
    FALSE
FROM Question_posts q
CROSS JOIN (
    SELECT user_id FROM user_accounts ORDER BY RAND() LIMIT 2
) u
WHERE q.user_id != u.user_id
LIMIT 50;

-- Follow (各ユーザーが5人程度フォロー)
INSERT INTO Follow (follow_id, following_user_id, followed_user_id)
SELECT 
    UUID(),
    u1.user_id,
    u2.user_id
FROM user_accounts u1
CROSS JOIN (
    SELECT user_id FROM user_accounts ORDER BY RAND() LIMIT 5
) u2
WHERE u1.user_id != u2.user_id
LIMIT 100;

-- Notification (各ユーザーに通知)
INSERT INTO Notification (notification_id, user_id, notification_type, source_id, body, is_read)
SELECT 
    UUID(),
    user_id,
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'transaction_update'
        WHEN 1 THEN 'system_alert'
        ELSE 'post_reply'
    END,
    UUID(),
    '新しい通知があります',
    RAND() > 0.5
FROM user_accounts
LIMIT 30;

-- ======================================================================
-- セクション 6: 取引データ (30件)
-- ======================================================================

-- transaction
INSERT INTO transaction (transaction_id, seller_id, buyer_id, product_id, transaction_status_id, transaction_type_id, started_at, completed_at, is_warranty_service)
SELECT 
    UUID(),
    (SELECT user_id FROM user_accounts ORDER BY RAND() LIMIT 1),
    (SELECT user_id FROM user_accounts ORDER BY RAND() LIMIT 1),
    product_id,
    FLOOR(1 + RAND() * 8),
    FLOOR(1 + RAND() * 2),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY),
    CASE WHEN RAND() > 0.5 THEN NOW() ELSE NULL END,
    RAND() > 0.7
FROM Products
LIMIT 30;

-- total_sales
INSERT INTO total_sales (total_sales_id, transaction_id, user_id, sales_amount, fee, is_paid_out)
SELECT 
    UUID(),
    t.transaction_id,
    t.seller_id,
    FLOOR(1000 + RAND() * 9000),
    FLOOR(100 + RAND() * 900),
    RAND() > 0.5
FROM transaction t
LIMIT 30;

-- evaluation
INSERT INTO evaluation (evaluation_id, transaction_id, seller_id, buyer_id, comment)
SELECT 
    UUID(),
    transaction_id,
    seller_id,
    buyer_id,
    'とても良い取引でした。また機会があればよろしくお願いします。'
FROM transaction
WHERE completed_at IS NOT NULL
LIMIT 20;

-- payment_method
INSERT INTO payment_method (payment_id, transaction_id, payment_method_id, cardholder_name, payment_number, payment_hashpass)
SELECT 
    UUID(),
    transaction_id,
    FLOOR(1 + RAND() * 4),
    'カード名義人',
    CONCAT('****', LPAD(FLOOR(RAND() * 10000), 4, '0')),
    '$2y$10$paymenthash'
FROM transaction
LIMIT 30;

-- ======================================================================
-- セクション 7: サポートデータ
-- ======================================================================

-- Contact (30件)
INSERT INTO Contact (inquiry_id, user_id, email, category, subject, body, status)
SELECT 
    UUID(),
    user_id,
    email,
    CASE FLOOR(RAND() * 4)
        WHEN 0 THEN 'アカウント'
        WHEN 1 THEN '取引'
        WHEN 2 THEN '通報'
        ELSE 'その他'
    END,
    CONCAT('問い合わせ件名', LPAD(@c_row := @c_row + 1, 3, '0')),
    'お問い合わせ内容の詳細です。',
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN '未対応'
        WHEN 1 THEN '対応中'
        ELSE '完了'
    END
FROM user_accounts, (SELECT @c_row := 0) r
LIMIT 30;

-- FAQ (30件)
INSERT INTO FAQ (faq_id, category, question, answer) VALUES
(UUID(), 'アカウント', 'アカウントの作成方法を教えてください', '登録ページから必要事項を入力してください。'),
(UUID(), 'アカウント', 'パスワードを忘れた場合はどうすればいいですか', 'パスワードリセットページからメールアドレスを入力してください。'),
(UUID(), 'レンタル', 'レンタル期間はどのくらいですか', '商品によって異なりますが、通常1週間から1ヶ月です。'),
(UUID(), 'レンタル', 'レンタル料金の支払い方法は', 'クレジットカード、銀行振込、PayPalなどが利用できます。'),
(UUID(), '配送', '配送料はかかりますか', '商品や地域によって異なります。詳細は商品ページをご確認ください。'),
(UUID(), '配送', '配送日時の指定はできますか', 'はい、注文時に配送日時を指定できます。'),
(UUID(), '返却', '返却方法を教えてください', '同梱の返送用伝票を使用してください。'),
(UUID(), '返却', '返却期限を過ぎた場合はどうなりますか', '延滞料金が発生する場合があります。'),
(UUID(), '保証', '保証サービスとは何ですか', '商品の破損や紛失時の補償サービスです。'),
(UUID(), '保証', '保証サービスの料金は', 'レンタル料金の10-20%程度です。'),
(UUID(), 'トラブル', '商品が届かない場合は', 'サポートセンターまでご連絡ください。'),
(UUID(), 'トラブル', '商品に不具合があった場合は', '速やかに交換対応いたします。'),
(UUID(), 'キャンセル', 'キャンセルはできますか', '発送前であればキャンセル可能です。'),
(UUID(), 'キャンセル', 'キャンセル料はかかりますか', '発送前は無料、発送後は手数料がかかります。'),
(UUID(), '評価', '評価はどのように行いますか', '取引完了後に評価ページから入力できます。'),
(UUID(), '評価', '評価は変更できますか', '一度投稿した評価は変更できません。'),
(UUID(), 'ポイント', 'ポイントの貯め方を教えてください', '取引完了時や評価投稿時にポイントが貯まります。'),
(UUID(), 'ポイント', 'ポイントの有効期限は', '最終利用日から1年間です。'),
(UUID(), 'クーポン', 'クーポンの使い方は', 'チェックアウト時にクーポンコードを入力してください。'),
(UUID(), 'クーポン', 'クーポンの併用はできますか', '一部のクーポンは併用可能です。'),
(UUID(), '会員', '会員ランクとは何ですか', '利用実績に応じて特典が受けられるシステムです。'),
(UUID(), '会員', 'プレミアム会員の特典は', '送料無料や優先サポートなどの特典があります。'),
(UUID(), 'セキュリティ', '個人情報は安全ですか', 'SSL暗号化により厳重に管理しています。'),
(UUID(), 'セキュリティ', '二段階認証の設定方法は', 'アカウント設定から有効化できます。'),
(UUID(), 'その他', 'ビジネス利用は可能ですか', 'はい、法人プランもご用意しております。'),
(UUID(), 'その他', '海外発送は対応していますか', '現在は国内のみの対応となっております。'),
(UUID(), 'その他', 'アプリはありますか', 'iOS/Android向けアプリを提供しています。'),
(UUID(), 'その他', 'お問い合わせ窓口は', 'メールまたは電話でお問い合わせください。'),
(UUID(), 'その他', '営業時間を教えてください', '平日9:00-18:00です。土日祝は休業です。'),
(UUID(), 'その他', 'よくある質問で解決しない場合は', 'お問い合わせフォームからご連絡ください。');

-- Notice (30件)
INSERT INTO Notice (notice_id, type, title, body, start_time, end_time, status) VALUES
(UUID(), 'メンテナンス', 'システムメンテナンスのお知らせ', '2025年10月20日 2:00-5:00にシステムメンテナンスを実施します。', '2025-10-15 00:00:00', '2025-10-25 00:00:00', '公開中'),
(UUID(), '重要', '利用規約改定のお知らせ', '利用規約を改定いたします。', '2025-10-10 00:00:00', NULL, '公開中'),
(UUID(), 'キャンペーン', '秋のキャンペーン開催中', 'レンタル料金20%OFF！', '2025-10-01 00:00:00', '2025-10-31 23:59:59', '公開中'),
(UUID(), 'お知らせ', '新機能追加のお知らせ', 'レビュー機能を追加しました。', '2025-10-05 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', 'アプリ更新のお知らせ', 'モバイルアプリをアップデートしました。', '2025-10-08 00:00:00', '2025-10-22 00:00:00', '公開中'),
(UUID(), '障害情報', 'システム障害のお詫び', '一時的な障害が発生しましたが、現在は復旧しております。', '2025-10-12 00:00:00', '2025-10-19 00:00:00', '公開中'),
(UUID(), 'メンテナンス', '定期メンテナンスのお知らせ', '毎月第3日曜日にメンテナンスを実施します。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), 'キャンペーン', '新規登録キャンペーン', '新規登録で1000ポイントプレゼント！', '2025-10-01 00:00:00', '2025-11-30 23:59:59', '公開中'),
(UUID(), 'お知らせ', '配送業者変更のお知らせ', '配送業者を変更いたしました。', '2025-09-25 00:00:00', '2025-10-25 00:00:00', '公開中'),
(UUID(), 'お知らせ', '年末年始営業のご案内', '年末年始の営業日についてお知らせします。', '2025-12-01 00:00:00', '2026-01-10 00:00:00', '公開中'),
(UUID(), 'イベント', 'オンラインイベント開催', 'ユーザー交流イベントを開催します。', '2025-10-18 00:00:00', '2025-10-25 00:00:00', '公開中'),
(UUID(), 'お知らせ', 'カスタマーサポート強化', 'サポート体制を強化しました。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), '重要', 'プライバシーポリシー改定', 'プライバシーポリシーを改定いたします。', '2025-09-15 00:00:00', '2025-10-31 00:00:00', '公開中'),
(UUID(), 'お知らせ', '決済方法追加のお知らせ', '新しい決済方法を追加しました。', '2025-10-10 00:00:00', NULL, '公開中'),
(UUID(), 'キャンペーン', '友達紹介キャンペーン', '友達を紹介すると両方に特典！', '2025-10-01 00:00:00', '2025-12-31 23:59:59', '公開中'),
(UUID(), 'お知らせ', 'サービスエリア拡大', '新たに5県でサービスを開始しました。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', '商品カテゴリ追加', '新カテゴリを追加しました。', '2025-10-05 00:00:00', NULL, '公開中'),
(UUID(), 'メンテナンス', '臨時メンテナンスのお知らせ', 'セキュリティ向上のためメンテナンスを実施します。', '2025-10-22 00:00:00', '2025-10-23 00:00:00', '公開中'),
(UUID(), 'お知らせ', 'ポイント制度改定', 'ポイント付与率を変更しました。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), 'キャンペーン', '季節限定商品追加', '冬の新商品を追加しました。', '2025-10-15 00:00:00', '2025-12-31 23:59:59', '公開中'),
(UUID(), 'お知らせ', 'アカウント連携機能追加', 'SNSアカウントと連携できるようになりました。', '2025-10-08 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', 'レビュー投稿でポイント', 'レビュー投稿で100ポイントプレゼント！', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), '重要', 'セキュリティ強化のお知らせ', 'セキュリティ機能を強化しました。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', 'チャット機能追加','ユーザー間でメッセージのやり取りが可能になりました。', '2025-10-12 00:00:00', NULL, '公開中'),
(UUID(), 'イベント', 'ユーザーアンケート実施中', 'アンケートにご協力ください。', '2025-10-10 00:00:00', '2025-10-30 23:59:59', '公開中'),
(UUID(), 'お知らせ', '配送時間指定サービス開始', 'より細かい時間指定が可能になりました。', '2025-10-01 00:00:00', NULL, '公開中'),
(UUID(), 'キャンペーン', '長期レンタル割引', '1ヶ月以上のレンタルで割引適用！', '2025-10-01 00:00:00', '2025-11-30 23:59:59', '公開中'),
(UUID(), 'お知らせ', 'カスタマーレビュー機能改善', 'より使いやすくなりました。', '2025-10-15 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', '商品検索機能強化', '検索精度が向上しました。', '2025-10-10 00:00:00', NULL, '公開中'),
(UUID(), 'お知らせ', 'お気に入り機能追加', '商品をお気に入りに登録できるようになりました。', '2025-10-05 00:00:00', NULL, '公開中');

-- Mannual_content (30件)
INSERT INTO Mannual_content (content_id, content_type, title, body) VALUES
(UUID(), '利用規約', '第1条：総則', '本規約は、本サービスの利用に関する条件を定めるものです。'),
(UUID(), '利用規約', '第2条：アカウント', 'ユーザーはアカウントを作成する必要があります。'),
(UUID(), '利用規約', '第3条：禁止事項', '以下の行為を禁止します。'),
(UUID(), '利用規約', '第4条：責任', '当社は適切な注意を払います。'),
(UUID(), '利用規約', '第5条：解約', 'ユーザーはいつでもアカウントを解約できます。'),
(UUID(), 'プライバシーポリシー', '個人情報の収集', '以下の個人情報を収集します。'),
(UUID(), 'プライバシーポリシー', '個人情報の利用', '収集した情報は以下の目的で利用します。'),
(UUID(), 'プライバシーポリシー', '個人情報の開示', '第三者への開示について。'),
(UUID(), 'プライバシーポリシー', 'クッキーの使用', 'クッキーを使用しています。'),
(UUID(), 'プライバシーポリシー', 'お問い合わせ', '個人情報に関するお問い合わせ先。'),
(UUID(), 'ガイドライン', 'レンタルの流れ', 'レンタルの手順を説明します。'),
(UUID(), 'ガイドライン', '商品の選び方', '商品を選ぶポイント。'),
(UUID(), 'ガイドライン', '配送について', '配送方法と料金について。'),
(UUID(), 'ガイドライン', '返却方法', '返却の手順を説明します。'),
(UUID(), 'ガイドライン', '評価システム', '評価の付け方について。'),
(UUID(), 'ヘルプ', 'アカウント登録', 'アカウント登録の手順。'),
(UUID(), 'ヘルプ', 'パスワード変更', 'パスワードの変更方法。'),
(UUID(), 'ヘルプ', '支払い方法', '利用可能な支払い方法。'),
(UUID(), 'ヘルプ', 'キャンセル方法', 'キャンセルの手順。'),
(UUID(), 'ヘルプ', 'トラブル対応', 'よくあるトラブルと対応方法。'),
(UUID(), 'FAQ', '基本的な使い方', 'サービスの基本的な使い方。'),
(UUID(), 'FAQ', '料金について', '料金体系の説明。'),
(UUID(), 'FAQ', '保証について', '保証サービスの説明。'),
(UUID(), 'FAQ', 'ポイントについて', 'ポイントシステムの説明。'),
(UUID(), 'FAQ', 'セキュリティ', 'セキュリティ対策について。'),
(UUID(), 'お知らせ', 'サービス開始のご案内', 'サービスを開始しました。'),
(UUID(), 'お知らせ', '機能追加のお知らせ', '新機能を追加しました。'),
(UUID(), 'お知らせ', '規約改定のお知らせ', '規約を改定しました。'),
(UUID(), 'お知らせ', 'メンテナンスのお知らせ', 'メンテナンスを実施します。'),
(UUID(), 'お知らせ', 'キャンペーンのお知らせ', 'キャンペーンを実施中です。');

-- ======================================================================
-- セクション 8: 管理者データ
-- ======================================================================

USE admin_DB;

-- admin_users (30件)
INSERT INTO admin_users (admin_first_name, admin_last_name, admin_birthday, admin_mail) VALUES
('太郎', '管理', '1985-01-01', 'admin001@example.com'),
('花子', '運営', '1986-02-02', 'admin002@example.com'),
('一郎', '佐々木', '1987-03-03', 'admin003@example.com'),
('美咲', '高橋', '1988-04-04', 'admin004@example.com'),
('健太', '田中', '1989-05-05', 'admin005@example.com'),
('由美', '伊藤', '1990-06-06', 'admin006@example.com'),
('翔太', '渡辺', '1991-07-07', 'admin007@example.com'),
('彩香', '山本', '1992-08-08', 'admin008@example.com'),
('大輔', '中村', '1993-09-09', 'admin009@example.com'),
('真理', '小林', '1994-10-10', 'admin010@example.com'),
('修平', '加藤', '1985-11-11', 'admin011@example.com'),
('優子', '吉田', '1986-12-12', 'admin012@example.com'),
('健一', '清水', '1987-01-13', 'admin013@example.com'),
('麻衣', '森田', '1988-02-14', 'admin014@example.com'),
('大樹', '池田', '1989-03-15', 'admin015@example.com'),
('春菜', '橋本', '1990-04-16', 'admin016@example.com'),
('隆太', '山崎', '1991-05-17', 'admin017@example.com'),
('美穂', '石井', '1992-06-18', 'admin018@example.com'),
('浩二', '前田', '1993-07-19', 'admin019@example.com'),
('紗希', '藤田', '1994-08-20', 'admin020@example.com'),
('誠', '岡田', '1985-09-21', 'admin021@example.com'),
('絵里', '長谷川', '1986-10-22', 'admin022@example.com'),
('雄介', '村上', '1987-11-23', 'admin023@example.com'),
('瞳', '近藤', '1988-12-24', 'admin024@example.com'),
('貴之', '後藤', '1989-01-25', 'admin025@example.com'),
('千尋', '青木', '1990-02-26', 'admin026@example.com'),
('智也', '西村', '1991-03-27', 'admin027@example.com'),
('沙織', '福田', '1992-04-28', 'admin028@example.com'),
('拓海', '太田', '1993-05-29', 'admin029@example.com'),
('夏美', '松本', '1994-06-30', 'admin030@example.com');

-- admin_authorities
INSERT INTO admin_authorities (admin_id, admin_user_post_perms, admin_inquiry_perms, admin_contract_type_perms, admin_admin_users)
SELECT 
    admin_id,
    FLOOR(RAND() * 2),
    FLOOR(RAND() * 2),
    FLOOR(RAND() * 2),
    CASE WHEN admin_id <= 5 THEN 1 ELSE 0 END
FROM admin_users;

-- ======================================================================
-- 完了メッセージ
-- ======================================================================
SELECT 'サンプルデータの挿入が完了しました！' AS Message;
