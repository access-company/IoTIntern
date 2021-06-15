# 管理者向け情報

- 開発環境としてはAWS EC2の使用を前提とする
- Gear開発時にはビジネスチャットアプリ「Linkit」との連携を前提とする

## 事前準備

### aws cli

- aws cliをインストールする
- aws cliを使用するためのプロファイルを設定する。プロファイル名は`iot_intern`とする
  - アクセスキーを設定する
    - IAMユーザーでアクセスキーを取得する
    - `~/.aws/credentials`に`[iot_intern]`として設定する
  - コンフィグを編集する
    - `~/.aws/config`に以下のように登録する
    ```
    [profile iot_intern]
    region = ap-northeast-1
    output = json
    ```

### SSH接続用の鍵の作成

管理者用とgear開発者用の、2つの鍵を作成しておく。
鍵の生成時に、WindowsのSSH Client向けに`ed25519`を使用したほうがいいという話があるので、`ed25519`を使用する。

- 管理者用のキーペア
  - `ssh-keygen -o -a 100 -t ed25519 -f iot-intern-admin-key`
  - 公開鍵はAMIを作成するとき、EC2起動時のユーザーデータに埋め込む
- Gear開発者用のキーペア
  - `ssh-keygen -o -a 100 -t ed25519 -f iot-intern-user-key`
  - 秘密鍵(`iot-intern-user-key`)はgear開発者に配布する
  - 公開鍵はAMIを作成するとき、EC2起動時のユーザーデータに埋め込む

## AWS環境設定

[セットアップドキュメント](./setup/aws.md)を参照。

## Gear開発用EC2インスタンスの運用

- AMIの作成 [(手順)](./operation/create_ami.md)
  - 処理系をupgradeする際やSSH接続用の鍵を更新する際もAMIを作り直す
- 必要な数のEC2インスタンスを起動 [(手順)](./operation/launch_instances_for_intern.md)
- EC2インスタンスを終了 [(手順)](./operation/terminate_instances_for_intern.md)
