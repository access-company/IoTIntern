# AMIの作成・更新

開発環境を揃えた状態のインスタンスを複数台起動できるようにするため、以下が完了したAMIを作成しておく。
- 管理者ユーザー・gear開発ユーザーの作成
- 開発に必要な処理系のインストール
- 開発リポジトリのclone
- Elixir hands-onの際に利用するjupyter notebookおよびElixir用のjupyter kernel
  - インスタンス起動時にjupyter serverが起動するようにしておく

## 手順

### EC2インスタンスの起動

- ユーザーデータとして[このスクリプト](../../../script/util/bootstrap_amazonlinux2.sh)を使用する。スクリプト冒頭の以下の項目を編集する
  - 使用する処理系のバージョン
    - `antikythera_instance_example`が依存している`antikythera`の[`.tool-versions`](../../../.tool-versions)の指定に合わせる
  - ユーザーのパスワード
  - (optional)変更する場合はSSH接続用の公開鍵
- [スクリプト](../../../script/aws/launch_makeami_instance.sh)でAMI作成用のインスタンスを起動する
  ```sh
  script/aws/launch_makeami_instance.sh script/util/bootstrap_amazonlinux2.sh
  ```
- `iot-intern-makeami-yyyymmdd`という名前のインスタンスが起動するので、SSH接続して初期化が完了していることを確認する
  - `/tmp/bootstrap_amazonlinux2_yyyymmddHHMM.log`の最後に`Finished all steps!`と出力されていることを確認する

### 手動セットアップが必要なもの

- LinkitのPost Message API (`POST /:app_id/:group_id/chat_rooms/:chatroom_id/messages`)の仕様書の設置
  - Linkitの仕様書は本来内部向けのドキュメントであり、publicであるこのレポジトリに含めるべきではないため手動で設置する
  - パスは`/home/intern-user/IoTIntern/doc/linkit_api.apib`とする
  - 拡張子は`.apib`とすること(VSCodeのAPI Blueprint Viewer拡張機能でプレビューするために必要)

### AMIの登録

- インスタンスをstopさせる
- インスタンスのidを指定して[AMI作成スクリプト](../../../script/aws/create_ami.sh)を実行する
  ```sh
  script/aws/create_ami.sh i-xxx
  ```
  - `iot-intern-yyyymmdd`という名前のAMIが作成される
  - AMI作成用のインスタンスはスクリプトにより自動的にterminateされる
- 作成したAMIのStatusが`available`になるのを待つ
