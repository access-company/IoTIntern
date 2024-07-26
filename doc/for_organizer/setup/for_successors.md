# 引き継いだ人向けのマニュアル

## 対象読者

インターンを引き継いで、これから環境構築を行う人を想定している。

## 事前準備
- IAMユーザー作成済み
- MFA設定済み

## 環境構築手順

### CloudShellのprofile設定

- AWSのマネジメントコンソールを開き、検索ボックスのところに「CloudShell」と入力する
- profileの設定を行う(セッションが切れるたびに行う)
  ```
  # 設定
  mkdir -p ~/.aws
  echo -e "[profile iot_intern]\nregion = ap-northeast-1\noutput = json" > ~/.aws/config
  # 確認
  cat ~/.aws/config
  ```

### SSHキーの準備

- Google Driveにある「インターンシップ共有用」→「credentials」からキーをダウンロードし、ローカル環境の`~/.ssh`に配置する
  - iot-intern-user-key
- `chmod 600 ~/.ssh/キーのファイル名`でパーミッションを変更する


### EC2インスタンスの立ち上げおよび動作確認

下記のドキュメントの手順に従ってEC2インスタンスを立ち上げて、動作確認を行う。

[doc/for_organizer/operation/launch_instances_for_intern.md](../operation/launch_instances_for_intern.md)

(補足)
- AWS関連のスクリプトはAWS CloudShell上で「アクション」→「ファイルをアップロード」でアップロードしてから実行する
- SSHはローカル環境から行う
