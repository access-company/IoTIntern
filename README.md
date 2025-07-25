# IotIntern

お掃除ロボットの死活監視を題材にしたインターンシップのプログラム一式。

## 動かし方

### 依存関係の取得

予め取得済みのものが AMI に含まれているので、場合に応じて行います。

```sh
mix deps.get && mix deps.get
```

### Web Server の起動

[gear_config.json](./gear_config.json)に下記の値を設定します。

`linkit_api_key`, `notification_user_credential`, `chatroom_id` は講師から共有されます。


```sh
$ cat gear_config.json
```
```json
{
  "linkit_app_id": "a_BjF4XHB2",
  "linkit_group_id": "g_YrTWTxJY",
  "linkit_api_key": "2t23xxxxxxxxxxxxxx",
  "notification_user_credential": "xxxxx",
  "chatroom_id": "xxxxxxxx"
}
```

下記コマンドで `gear_config.json` に書かれた値を環境変数に指定した状態で、Web Server を起動できます。
```sh
IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) iex -S mix
```

### シミュレータからの確認

Web Server を起動した状態でブラウザから
http://iot-intern.localhost:8080/ui/index.html
にアクセスします。

### Linkit へのメッセージ送信の確認

Linkit アカウント登録完了メールにパスワードが記載されているので、メール記載のリンクから Linkit を開いてください。

## リポジトリレイアウト

```
.
├── README.md
├── deps // mix deps.get でパッケージが入る
├── doc // ドキュメント
├── gear_config.json // コンフィグファイル
├── lib // 自作のライブラリ記述先
├── mix.exs // mix project の設定（触らない）
├── mix.lock // 依存パッケージの version 一覧 (触らない)
├── priv // シミュレータ画面のような静的コンテンツ
├── test // テストコード
└── web // API 記述先
```

## API 追加のやり方

API を追加するには「コントローラーの処理を書くこと」と「ルーターのパスを設定する」の二つを行います。

### コントローラーの処理を書く

[`web/controller/hello.ex`](web/controller/hello.ex) のようにモジュールと関数を定義します。

`Hello` モジュールの `hello/1` 関数は第一引数に `conn` を受け取り、新しい`conn` を返します。そしてレスポンスのコンテンツを `conn` に詰めるには関数 `Conn.json/3` を使っています。

### ルーターのパスを書く

[`web/router.ex`](web/router.ex) を書き換えます。

## テストの実行

全ての `*_test.exs` ファイルを対象に実行するには、下記コマンドを実行します。

```sh
IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test
```

特定のテストファイルを対象に実行するには、下記コマンドを実行します。

```sh
IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test test/web/controller/hello_test.exs
```

## お掃除ロボットの API 実装課題

[apidoc branch](https://github.com/access-company/IoTIntern/tree/apidoc) 上の [仕様書](https://github.com/access-company/IoTIntern/blob/apidoc/doc/api.apib) と [シーケンス図](https://github.com/access-company/IoTIntern/blob/apidoc/doc/sequence.puml) の通りに実装することを目指します。
下記の課題に従って実装を進めてください。

- [例題](./doc/tasks/example.md)
- [課題 1](./doc/tasks/task1.md)
- [課題 2](./doc/tasks/task2.md)
- [課題 3](./doc/tasks/task3.md)
- [課題 4](./doc/tasks/task4.md)
- [発展課題](./doc/tasks/advanced_task.md)
