# 課題 3

## 課題

- lib/linkit.ex のコメントアウトを解除し、適宜コードを補完して関数を完成させて、alert API 経由で Linkit へ通知が送れるようにしてください
- `IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test` を実行してテストが成功することを確認してください

## 期待結果

- テストが成功する

  ```shell
  $ IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test test/lib/linkit_test.exs
  … (省略) 3 tests, 0 failures
  ```

- お掃除ロボットシミュレータの障害発生時、または下記のコマンド実行時に Linkit app にメッセージが届く

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{"type": "dead_battery"}' -w '\n%{http_code}\n'
  {"sent_at":"2021-06-18T06:59:41Z"}
  200
  ```

## 補足

Linkit API の仕様書は、別途共有された linkit_api.apib を参照ください。
