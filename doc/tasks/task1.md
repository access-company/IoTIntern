# 課題 1

## 課題

[仕様](../api.apib) に沿って時刻を返すように [alert API](web/controller/alert.ex) を実装してください。

## 期待結果

- curl でリクエストを行うと `sent_at` が返される

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{}' -w '\n%{http_code}\n'
  {"sent_at":"2021-06-18T06:26:53Z"}
  200
  ```

- お掃除ロボットシミュレータの画面に、メッセージの送信日時が表示される

## 補足

[DateTime モジュール](https://hexdocs.pm/elixir/1.12/DateTime.html) のドキュメントを参照してください。
