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
- [vscode-elixir](https://marketplace.visualstudio.com/items?itemName=mjmcloug.vscode-elixir): syntax highlightingや入力補完ができるようになる
    - [Elixir-LS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)のほうが定義の参照や定義箇所への移動ができるなど高機能だが、下記の問題により無視できない不便さが生じたため使用していない
        - IoTInternで利用する際、最新のものではなくバージョン0.5.0を利用しなければ拡張機能がクラッシュする(AntikytheraがErlangバージョン20系を要求することによる)
        - IoTIntern gearコンパイル時にhexパッケージのコンパイルが失敗する場合がある(バックグラウンドでElixir-LSによるgearコンパイルが進行している時に処理がバッティングすることによる)

### インストール

リモートマシン上で、[このスクリプト](../../script/util/install_vscode_extensions.sh)を実行する。

```sh
./script/util/install_vscode_extensions.sh
```
