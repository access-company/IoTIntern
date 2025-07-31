# 例題

## 課題

アラート送信 API は [alert.ex](/web/controller/alert.ex) として用意されていますが、中身はまだ実装されておらず、空のレスポンスをステータス200で返すようになっています。

リモート環境 (EC2) の VSCode ターミナルから curl を利用して、`api/v1/alert` に対して POST メソッドでリクエストを送ってみましょう。※ iexを開いているターミナルとは別のターミナルで行ってください。

以下の期待結果が得られるか確認してください。

## 期待結果

```shell
$ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{}' -w '\n%{http_code}\n'
```
```plain
{}
200
```

## 補足

お掃除ロボットシミュレータ上では、「メッセージ送信完了日時」が `undefined` と表示されます。
