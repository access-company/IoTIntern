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
