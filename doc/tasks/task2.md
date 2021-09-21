# 課題 2

## 課題

無効なリクエストボディの場合にレスポンス 400 が返るようにしてください。

## 期待結果

- リクエストボディが有効な場合

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{"type": "dead_battery"}' -w '\n%{http_code}\n'
  {"sent_at":"2021-06-18T06:26:53Z"}
  200
  ```

- リクエストボディが無効な場合

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{"type": "hello"}' -w '\n%{http_code}\n'
  {"message":"Unable to understand the request","type":"BadRequest"}
  400
  ```

## 補足

リクエストボディは `%{body: _body}` を `%{body: body}` とすると body をコードで利用することが出来ます。
