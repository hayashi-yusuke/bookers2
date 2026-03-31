Bookers2 📚
読書記録・共有アプリ。本の投稿・評価・タグ管理・ユーザー間交流をひとつにまとめたSNS型サービスです。

📋 目次

アプリ概要
機能一覧
使用技術
ER図
環境構築
テスト


アプリ概要
Bookers2 は、読んだ本を記録・共有できる読書SNSアプリです。
本の投稿・5段階評価・カテゴリタグ・フォロー・DM・グループなど、ユーザー同士が本を通じてつながれる機能を備えています。

機能一覧
👤 ユーザー機能
機能説明サインアップ / ログインメールアドレスとパスワードで認証プロフィール編集名前・自己紹介・アバター画像の変更フォロー / フォロワー他ユーザーをフォローして投稿を追う投稿数統計グラフChart.js による日別・期間別の投稿数可視化
📚 本の投稿機能
機能説明投稿 / 編集 / 削除本のタイトル・本文・画像を投稿いいね気に入った投稿にいいねを付けるコメント投稿に対してコメントを残す閲覧数カウント詳細ページの閲覧数を自動記録・表示5段階評価Raty.js を使った星評価 / 並び替え新着順 / 評価の高い順で一覧を切り替えカテゴリタグタグを付けて分類・クリックで絞り込み検索
🔍 検索機能
機能説明キーワード検索タイトル・本文での全文検索タグ検索タグをクリックして同カテゴリの本を一覧表示日付検索 / Turbo Frame を利用したリアルタイム日付絞り込み
💬 コミュニケーション機能
機能説明1対1 DM相互フォロー限定・140文字制限のダイレクトメッセージグループグループの作成・編集・削除（オーナー権限）グループ参加 / 脱退メンバーの参加・脱退が可能イベント通知メールletter_opener_web によるメール送信

使用技術
バックエンド
技術バージョンRuby on Rails8.1SQLite3開発・テスト環境
フロントエンド
技術用途Bootstrap 5UIコンポーネント・レイアウトSCSS / BEMスタイル設計SlimテンプレートエンジンChart.js統計グラフ描画Raty.js星評価UIHotwire (Turbo / Stimulus)非同期UI更新
開発環境
ツール用途AWS Cloud9クラウドIDERSpecテストフレームワークRuboCopRubyコード静的解析letter_opener_web開発環境でのメール確認

ER図
users
├── has_many :books
├── has_many :reviews
├── has_many :likes
├── has_many :comments
├── has_many :relationships (フォロー)
├── has_many :messages
└── has_many :group_users

books
├── belongs_to :user
├── has_many :reviews
├── has_many :likes
├── has_many :comments
├── has_many :book_tags
└── has_many :tags, through: :book_tags

tags
└── has_many :books, through: :book_tags

reviews
├── belongs_to :user
└── belongs_to :book

groups
├── has_many :group_users
└── has_many :users, through: :group_users

環境構築
1. リポジトリをクローン
bashgit clone https://github.com/your-username/bookers2.git
cd bookers2
2. Gemをインストール
bashbundle install
3. データベースを作成
bashrails db:create
rails db:migrate
rails db:seed   # サンプルデータが必要な場合
4. サーバーを起動
bashrails server
ブラウザで http://localhost:3000 にアクセスしてください。

テスト
RSpec でテストを実行します。
bash# 全テストを実行
bundle exec rspec

# 特定のファイルだけ実行
bundle exec rspec spec/models/user_spec.rb

作者
hayashi-yusuke
