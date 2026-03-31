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
- [OpenAPI (Swagger) Editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi): OpenAPI形式の仕様書を編集・プレビュー可能
- [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph): Gitのコミットグラフを可視化できる
- [Lexical](https://marketplace.visualstudio.com/items?itemName=lexical-lsp.lexical): Elixirの言語サーバー。syntax highlighting、入力補完、定義の参照・移動が可能
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker): スペルチェッカー

### インストール

リモートマシン上で、[このスクリプト](../../script/util/install_vscode_extensions.sh)を実行する。

```sh
./script/util/install_vscode_extensions.sh
```
