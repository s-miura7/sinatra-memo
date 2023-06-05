# sinatra-memo

## 手順

1. ターミナルで下記コマンドを打つ

```
$ bundle install
```

2.データベースを作る

- PostgreSQL をインストール
  例)MacOS(homebrew を使用)の場合は下記コマンド

```
$ brew install postgresql
```

- 下記コマンドで PostgreSQL のサーバーを起動

```
$ psql -U postgres
```

- データベースの作成(ここではデーターベース名を memo としている)

```
postgres=# CREATE DATABASE memo;
```

3. main.rb の下記部分を自分のデータベース名に変更

```ruby
my_db_name = 'memo'
```

4. ターミナルで下記コマンドを打つ

```
$ ruby main.rb
```

5. http://127.0.0.1:4567/memosを開く
