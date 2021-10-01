# IotIntern

お掃除ロボットの死活監視を題材にしたインターンシップのプログラム一式。

## 動かし方

### 依存関係の取得

予め取得済みのものが AMI に含まれているので、場合に応じて行う。

```sh
mix deps.get && mix deps.get
```

### Web Server の起動

Linkit アカウント登録完了メールにパスワードが記載されているので、メール記載のリンクから Linkit を開いてください。

[Gear コンフィグ](./gear_config.json)に下記の値を設定する。

`linkit_api_key`, `notification_user_credential`, `chatroom_id` は事前に共有される。


```sh
$ cat gear_config.json
{
  "linkit_app_id": "a_BjF4XHB2",
  "linkit_group_id": "g_YrTWTxJY",
  "linkit_api_key": "2t23xxxxxxxxxxxxxx", // 要確認
  "notification_user_credential": "xxxxx",
  "chatroom_id": "xxxxxxxx"
}
```

```sh
IOT_INTERN_CONFIG_JSON=`cat gear_config.json` iex -S mix
```

### シミュレータからの確認

Web Server を起動した状態でブラウザから
http://iot-intern.localhost:8080/ui/index.html
にアクセスする。

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

## Antikythera概要

### WebサーバーとしてのAntikythera

[Antikythera](https://github.com/access-company/antikythera)は複数のwebサービスをホスティングするPlatform as a Serviceである。
Antikytheraにホスティングされた個々のwebサービスをgearと呼んでいる。
AntikytheraはErlang VM上で動くErlangプロセスの1つであり、gearもまたAntikytheraと同じErlang VM上で動いている。

- Antikytheraの機能
    - HTTPサーバー
      - クライアントからのHTTPリクエストに対し、Antikytheraが管理しているErlangプロセスを使ってgearの関数を呼び出し、処理を行う
      - 処理結果をHTTPリクエストとしてクライアントに返す
    - Web Socketの管理
    - (図には書いていないが) gearが任意の非同期処理を行うための機能提供

![Overview of antikythera framework](/overview_of_antikythera.png)

### HTTPリクエストに対しHTTPレスポンスが返るまでの流れ

1. AntikytheraがクライアントからのHTTPリクエストを受け取る
2. Antikytheraがgearの関数を呼び出す
   1. リクエストURLによって処理を行うgearが決まる
       - サブドメインに基づく
   2. リクエストのメソッドとURLのパスによって処理を行う関数が決まる
       - gearの`web/router.ex`に基づく
       - このファイルにはメソッド・パスの組に対して呼び出されるべき関数(コントローラーと呼ぶ)が定義されている
   3. gearのコントローラーが実行される
       - コントローラーはHTTPリクエストを表すデータ構造を受け取り、HTTPレスポンスを表すデータ構造を返す関数
       - レスポンスボディは必要に応じてHTMLやJSONに加工する(ビューの関数を呼び出す)
3. AntikytheraがクライアントにHTTPレスポンスを返す

Gear開発者はコントローラーを起点として、HTTPリクエストに対しどのような処理を行うべきか、どのようなHTTPレスポンスを返すべきかに集中すればいい。

## API 追加のやり方

API を追加するには"コントローラーの処理を書くこと"と"ルーターのパスを設定する" の二つを行う。

### コントローラーの処理を書く

[`web/controller/hello.ex`](web/controller/hello.ex) のようにモジュールと関数を定義する。

`Hello` モジュールの `hello/1` 関数は第一引数に `conn` を受け取り、新しい`conn` を返す。そしてレスポンスのコンテンツを `conn` に詰めるには関数 `Conn.json/3` を使っている。

### ルーターのパスを書く

[`web/router.ex`](web/router.ex) を書き換える。

## テストの実行

全ての `*_test.exs` ファイルを対象に実行するには

```sh
IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test
```

または特定のテストファイルに対して下記のように行う。

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
