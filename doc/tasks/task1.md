# 課題 1

## 課題

- `IO.inspect` で `conn` の内容を確認してください
- [仕様](https://github.com/access-company/IoTIntern/blob/apidoc/doc/api.apib) に沿って時刻を返すように [alert API](https://github.com/access-company/IoTIntern/blob/apidoc/web/controller/alert.ex) を実装してください

## 期待結果

- curl でリクエストを行うと `sent_at` が返される

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{}' -w '\n%{http_code}\n'
  {"sent_at":"2021-06-18T06:26:53Z"}
  200
  ```

- お掃除ロボットシミュレータの画面に、メッセージの送信日時が表示される

## 補足

[DateTime モジュール](https://hexdocs.pm/elixir/1.9/DateTime.html) のドキュメントを参照してください。
