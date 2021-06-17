# 管理者用SSH接続設定

Gear開発中にトラブルが起こった時、対象のEC2インスタンスへのSSH接続を楽にするための設定。
SSH接続対象のEC2インスタンスが稼働していることを前提とする。

## 初回

- iot-internインスタンス用のSSH Configを[このスクリプト](../../../script/aws/generate_ssh_config.sh)で出力する
  ```sh
  script/aws/generate_ssh_config.sh > ~/.ssh/config.iot-intern
  ```
- `~/.ssh/config`に1行`Include ~/.ssh/config.iot-intern`を追記する

## 接続確認

- `ssh iot-intern-0`(末尾は`0`始まりの連番の数字)
- ログインユーザーは`intern-admin`となる

## 接続先の更新

EC2インスタンスを入れ替えた場合は設定を再生成する。
```sh
script/aws/generate_ssh_config.sh > ~/.ssh/config.iot-intern
```
