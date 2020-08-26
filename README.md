# IotIntern

お掃除ロボットの死活監視を題材にしたインターンシップのプログラム一式。

## 動かし方

### 依存関係の取得

```
mix deps.get && mix deps.get
```

### Web Server の起動

```
iex -S mix
```

### シミュレータからの確認

Web Server を起動した状態でブラウザから
http://iot-intern.localhost:8080/ui/index.html
にアクセスする。

## リポジトリレイアウト

```
[IoTIntern]$tree -L 1
.
├── README.md
├── api_test.http // VSCode の REST Client で使う
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

API を追加するには"コントローラーの処理を書くこと"と"ルーターのパスを設定する" の二つを行う。

### コントローラーの処理を書く

`web/controller/hello.ex` のようにモジュールと関数を定義する。

`Hello` モジュールの `hello/1` 関数は第一引数に `conn` を受け取り、新しい`conn` を返す。そしてレスポンスのコンテンツを `conn` に詰めるには関数 `Conn.json/3` を使っている。

### ルーターのパスを書く

`web/router.ex` を書き換える。

## テストの実行

全ての `*_test.exs` ファイルを対象に実行するには

```
mix test
```

または特定のテストファイルに対して下記のように行う。

```
mix test test/web/controller/hello_test.exs
```
