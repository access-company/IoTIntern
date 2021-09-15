# 受講者の成果物をダウンロード

EC2インスタンス上の`/home/intern-user/IoTIntern`をローカルにダウンロードする。

## 前提

- ダウンロード対象のEC2インスタンスには、tagとして`Name:iot-intern`が設定されているものとする
- 全てのインスタンスで`intern-user`用のSSH鍵が共通であるとする

## 手順

[ダウンロードスクリプト](../../../script/aws/download_work_of_participants.sh)を実行する。

```sh
script/aws/download_work_of_participants.sh <path_to_ssh_key_for_intern-user>
```

ローカルにダウンロードされたディレクトリのパスは`IoTIntern/tmp-downloaded/<現在時刻>/iot-intern-<数字>`。
`iot-intern-<数字>`の部分は[このスクリプト](../../../script/aws/list_public_ip_addresses.sh)で出力されるものと一致する。
