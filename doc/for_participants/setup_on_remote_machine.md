# リモートマシン上でのセットアップ

前提として、カレントディレクトリが`IoTIntern`ディレクトリであることとする。
確認方法は、下記のコマンド。
```sh
$ pwd
/home/intern-user/IoTIntern
```

## リモートマシンへのVSCode拡張機能のインストール

IoTInternでの開発を行う際に以下の拡張機能を利用する。

- [Plant UML](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml): シーケンス図のレンダリングが可能
- [API Blueprint Viewer](https://marketplace.visualstudio.com/items?itemName=develiteio.api-blueprint-viewer): OpenAPI形式の仕様書をレンダリング可能
- [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph): Gitのコミットグラフを可視化できる
- [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls): syntax highlightingや入力補完、定義の参照や定義箇所への移動ができるようになる
    - IoTInternで利用する際、最新のものではなくバージョン0.5.0を利用する必要がある
    - これはIoTInternが依存するAntikytheraでErlangバージョン20系を使用していることによる

### インストール

リモートマシン上で、[このスクリプト](../../script/util/install_vscode_extensions.sh)を実行する。

```sh
./script/util/install_vscode_extensions.sh
```
