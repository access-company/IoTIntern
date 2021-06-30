# ローカルで使用するツールのセットアップ

エディタとして[Visual Studio Code](https://code.visualstudio.com/)(VSCode)の使用を前提とする。
理由としては、Remote-SSH拡張機能をインストールすることで、リモートマシン上で開発する環境を手軽に準備できるためである。

- VSCode
- Linkit

## VSCodeのインストール

- [ここ](https://code.visualstudio.com/)からダウンロードしてインストール
  - Visual Studioではないことに注意すること
- Macを使用している場合、[この記事](https://qiita.com/ayatokura/items/69c96306e3dee501e19b)を参考にターミナルから`code`コマンドでVSCodeを起動できるようにする

### VSCode拡張機能のインストール

拡張機能のページを開き、以下のものを拡張機能名で検索してインストールする。
「Install」ボタンを押して表示されるダイアログに従い、VSCodeにインストールする。

- [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh): (必須) ローカルのVSCodeからリモートマシン上のファイルを編集するために必要

## Linkit

Linkitには[アプリ版](https://support.jin-soku.biz/support/solutions/articles/48001140891-linkit%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3%E6%96%B9%E6%B3%95%EF%BC%88%E3%82%A2%E3%83%97%E3%83%AA%E7%89%88%EF%BC%89)(Android・iOS)と[ブラウザ版](https://support.jin-soku.biz/support/solutions/articles/48001140888-linkit%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3%E6%96%B9%E6%B3%95)があり、少なくともいずれかを使用できればOK。
- アプリ版を利用する場合、ストアからインストールしておく
- 管理者からメールでログイン情報が送られるので、それを用いてログインできることを確認する
