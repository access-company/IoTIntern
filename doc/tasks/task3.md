# 課題 3

lib/linkit.ex のコメントアウトを解除し、適宜コードを補完して関数を完成させてください。

課題A、課題Bどちらから始めてもらっても構いません。

## 課題A

- alert API 経由で Linkit へ通知が送れるようにしてください。

### 期待結果

- お掃除ロボットシミュレータの障害発生時、または下記のコマンド実行時に Linkit app にメッセージが届く。

  ```shell
  $ curl -X POST "http://iot-intern.localhost:8080/api/v1/alert" -H "Content-Type: application/json" -d '{"type": "dead_battery"}' -w '\n%{http_code}\n'
  ```
  ```plain
  {"sent_at":"2021-06-18T06:59:41Z"}
  200
  ```

### ヒント

Linkit API の仕様書は、別途共有された linkit_api.apib を参照ください。

課題Aが完成すれば、お掃除ロボットシミュレータを動かすとLinkitの方に通知が来るはずです。
Web Server を起動した状態でブラウザから http://iot-intern.localhost:8080/ui/index.html にアクセスして試してみてください。

## 課題B

- `IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test` を実行してテストが成功することを確認してください。

### 期待結果

- テストが成功する

  ```shell
  $ IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test test/lib/linkit_test.exs
  ```
  ```plain
  … (省略) 3 tests, 0 failures
  ```

### ヒント

テストコードは [test/lib/linkit_test.exs](https://github.com/access-company/IoTIntern/blob/master/test/lib/linkit_test.exs) に既に実装済みです。まずはこのテストが何のテストをしているのかを考えてみましょう。

## テストとは

テストは、ソフトウェアやアプリケーションが意図した動作をしているか、または特定の要件や仕様を満たしているかを確認するために行います。

### テストを行うメリット

#### 品質の向上と信頼性の確保
テストを実施することでバグを早期に発見でき、リファクタリング時の品質劣化（デグレ）も防ぐことができます。その結果、コードの品質を高めることが可能です。

#### 安心して開発を進められる
テストが存在することで、コードを変更しても正しく動作するという安心感を得ることができ、開発者の不安を軽減できます。

#### 設計の改善につながる
テストが書きにくいコードは、設計に問題があることが多いため、テストを書くことを意識することで設計の見直しが促され、より良いアーキテクチャにすることができます。

#### ドキュメントとしての役割を果たす
テストコードは、仕様や動作の具体例を示すドキュメントとして機能し、要件や仕様の理解を深める助けとなります。

#### 開発効率の向上
バグ対応や設計ミスによる手戻りを減らすことができるため、最終的には工数の削減につながります。

### meck の使い方

- Elixir講義の7章にも説明があります。
- [`meck`](https://github.com/eproxus/meck) は erlang/elixir のモックライブラリです。
- モックする必要性
  - 外部サーバーに依存せずにテストを行うことができるので test が安定化します。
  - 任意の固定値を返せるので、異常ケース等をシミュレーションできます。
- サンプル実装
  - `test/web/controller/hello_test.exs`
- `meck.expect/3` を使うことで下記のように function の動作をモックできます。

  ```elixir
  defmodule Hoge do
    def foo(x) do
      x + 1
    end
  end

  > Hoge.foo(1)
  2

  # Hoge.foo/1の処理を書き換える
  :meck.expect(Hoge, :foo, fn(x) -> x + 2 end)

  > Hoge.foo(1)
  3
  ```

  ※引数の数は正確に記述する必要があります。数が違っているとmockが適用されません。

  ```elixir
  defmodule Hoge do
    # 引数が2つの関数を定義
    def foo(x, y) do
      x + y
    end
  end

  > Hoge.foo(1, 2)
  3

  # `fn`の引数が2つになるように定義
  :meck.expect(Hoge, :foo, fn(x, y) -> x + y + 2 end)

  > Hoge.foo(1, 2)
    5
  ```
