# 管理者向け情報

## 対象読者

- 一から環境構築をした際の状況が知りたい人
- 引き継ぎをした人向けのマニュアルは[./setup/for_successors.md](./setup/for_successors.md)にある。

## 前提条件

- AWS CLIを使う場合は[AWS CloudShell](https://aws.amazon.com/jp/cloudshell/)を使うことを前提とする
- 開発環境としてはAWS EC2の使用を前提とする
- Gear開発時にはビジネスチャットアプリ「Linkit」との連携を前提とする

## 事前準備

### AWS CloudShellを用いたAWS CLIの実行方法

- AWSのマネジメントコンソールを開き、検索ボックスのところに「CloudShell」と入力する
- profileの設定を行う
  ```
  mkdir -p ~/.aws
  echo -e "[profile iot_intern]\nregion = ap-northeast-1\noutput = json" > ~/.aws/config
  cat ~/.aws/config
  ```

AWS関連のスクリプトは「アクション」→「ファイルをアップロード」でアップロードしてから実行する。

### SSH接続用の鍵の作成

管理者用とgear開発者用の、2つの鍵を作成しておく。
鍵の生成時に、WindowsのSSH Client向けに`ed25519`を使用したほうがいいという話があるので、`ed25519`を使用する。

- 管理者用のキーペア
  - `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/iot-intern-admin-key`
  - 公開鍵はAMIを作成するとき、EC2起動時のユーザーデータに埋め込む
- Gear開発者用のキーペア
  - `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/iot-intern-user-key`
  - 秘密鍵(`iot-intern-user-key`)はgear開発者に配布する
  - 公開鍵はAMIを作成するとき、EC2起動時のユーザーデータに埋め込む

## AWS環境設定

[セットアップドキュメント](./setup/aws.md)を参照。

## Gear開発用EC2インスタンスの運用

- AMIの作成 [(手順)](./operation/create_ami.md)
  - 以下のケースでAMIの作り直しが必要
    - 処理系をupgradeするとき
    - SSH接続用の鍵やユーザーパスワードを更新するとき
    - このレポジトリのmasterブランチを更新したとき
    - [Elixir講座のレポジトリのmasterブランチ](https://github.com/Fumipo-Theta/elixir-training)が更新された時
- 必要な数のEC2インスタンスを起動 [(手順)](./operation/launch_instances_for_intern.md)
- 受講者の成果物をローカルにダウンロード [(手順)](./operation/download_work_of_participants.md)
- EC2インスタンスを終了 [(手順)](./operation/terminate_instances_for_intern.md)
