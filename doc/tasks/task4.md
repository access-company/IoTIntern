# 課題 4

## 課題

Alert API のテストコードを書いてみてください。

## 期待結果

テストが成功する。

```shell
$ IOT_INTERN_CONFIG_JSON=$(cat gear_config.json) mix test
```
```plain
2021-06-18T07:04:56.587+00:00 [info ] :syn_registry_table was successfully created

2021-06-18T07:04:56.587+00:00 [info ] :syn_groups_table was successfully created

Excluding tags: [:blackbox_only]

.........

Finished in 0.8 seconds
9 tests, 0 failures

Randomized with seed 791970
```

### ヒント

テストファイルは [test/web/controller/alert_test.exs](https://github.com/access-company/IoTIntern/blob/master/test/web/controller/alert_test.exs) に既に用意されています。

### JSONオブジェクトのパース・エンコード

Elixir講義の7章を参照してみてください。
