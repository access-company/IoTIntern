## Antikythera概要

### WebサーバーとしてのAntikythera

[Antikythera](https://github.com/access-company/antikythera)は複数のwebサービスをホスティングするPlatform as a Serviceです。
Antikytheraにホスティングされた個々のwebサービスをgearと呼んでいます。
AntikytheraはErlang VM上で動くErlangプロセスの1つであり、gearもまたAntikytheraと同じErlang VM上で動いています。

- Antikytheraの機能
    - HTTPサーバー
      - クライアントからのHTTPリクエストに対し、Antikytheraが管理しているErlangプロセスを使ってgearの関数を呼び出し、処理を行います。
      - 処理結果をHTTPレスポンスとしてクライアントに返します。
    - Web Socketの管理
    - (図には書いていないが) gearが任意の非同期処理を行うための機能提供

![Overview of antikythera framework](/overview_of_antikythera.png)

### HTTPリクエストに対しHTTPレスポンスが返るまでの流れ

1. AntikytheraがクライアントからのHTTPリクエストを受け取ります。
2. Antikytheraがgearの関数を呼び出します。
   1. リクエストURLによって処理を行うgearが決まります。
       - サブドメインに基づく
   2. リクエストのメソッドとURLのパスによって処理を行う関数が決まります。
       - gearの`web/router.ex`に基づく
       - このファイルにはメソッド・パスの組に対して呼び出されるべき関数(コントローラーと呼ぶ)が定義されています。
   3. gearのコントローラーが実行されます。
       - コントローラーはHTTPリクエストを表すデータ構造を受け取り、HTTPレスポンスを表すデータ構造を返す関数です。
       - レスポンスボディは必要に応じてHTMLやJSONに加工します(ビューの関数を呼び出します)
3. AntikytheraがクライアントにHTTPレスポンスを返します。

Gear開発者はコントローラーを起点として、HTTPリクエストに対しどのような処理を行うべきか、どのようなHTTPレスポンスを返すべきかに集中することができます。
