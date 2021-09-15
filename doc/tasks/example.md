# 例題

## 課題

開始時のコードは空のレスポンスをステータス200で返すようになっています。
リモート環境 (EC2) の VSCode ターミナルから curl を利用して期待結果が得られるか確認してください。

## 期待結果

```shell
$ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{}' -w '\n%{http_code}\n'
{}
200
```

## 補足

お掃除ロボットシミュレータ上では、「メッセージ送信完了日時」が `undefined` と表示されます。
