# 課題 4

## 課題

Alert API のテストコードを書いてみてください。

## 期待結果

テストが成功する。

```shell
$ IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test
2021-06-18T07:04:56.587+00:00 [info ] :syn_registry_table was successfully created

2021-06-18T07:04:56.587+00:00 [info ] :syn_groups_table was successfully created

Excluding tags: [:blackbox_only]

.........

Finished in 0.8 seconds
9 tests, 0 failures

Randomized with seed 791970
```

## 補足

### なぜテストを書くのか

- リファクタリングの際のデグレ（品質劣化）を検知できる
  - 課題５でリファクタリングを行います
- 設計を見直すことができる
  - テストが書きにくいプログラムというは、そもそも設計に問題があることが多い
  - テストを書きやすい設計は、個々の責務のハッキリした良い設計であることが多い
- プログラマの不安の低減
  - 変更に強いコードにできる
- テストコードはドキュメントでもある
  - 要件・仕様理解
- 結果的に
  - コードの品質が高くなる
  - 工数を削減できる

### JSONオブジェクトのパース・エンコード

Elixir講義の7章を参照してみてください。

### meck の使い方

- Elixir講義の7章にも説明があります
- [`meck`](https://github.com/eproxus/meck) は erlang/elixir のモックライブラリ
- モックする必要性
  - 外部サーバーに依存せずにテストを行うことができるので test が安定化する
  - 任意の固定値を返せるので、異常ケース等をシミュレーションできる
- サンプル実装
  - test/web/controller/hello_test.exs
- `meck.expect/3` を使うことで下記のように function の動作をモックできます

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
