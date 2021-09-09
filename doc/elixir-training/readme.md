# Elixir training

Elixirの基本的な文法の学習のためのドキュメント集である。

Elixirのコードを試すだけなら`iex`が最も手軽だが、複数行にわたるコードを書いたり、コードの一部を変更して試行錯誤的に実験する際には不便である。
これらの問題が解消されることと、コードとその実行結果がセットで記録に残ることの有用さによりJupyter notebookを使用している。

## セットアップ

Jupyter notebookと、Elixirの実行環境が必要である。
- ここでは準備を簡易化するためDockerを使用する
- Jupyter notebook上でElixirコードを実行するため、[IElixir](https://github.com/pprzetacznik/IElixir)を使用する
  - ErlangとElixirのバージョンは[IElixirが使用するbase image](https://github.com/pprzetacznik/IElixir/blob/master/docker/ielixir-requirements/Dockerfile)で指定されたものになる

なお、notebookの実行環境として、後発で高機能なJupyter labも選択可能であるが、現時点ではElixirコードのシンタックスハイライトやコード補完が効かず不便なため使用していない。

### ローカルで使用するツールのインストール

`docker`と、`docker compose`または`docker-compose`コマンドが使えればいい。
1. `docker`と`docker compose`
  - [Dockerのインストール](https://docs.docker.jp/get-docker.html)
  - [Docker Composeのインストール](https://docs.docker.jp/compose/install.html#compose)
2. Vagrant & VirtualBox
  - VMの中に`docker`, `docker-compose`をインストールし、VM内でコンテナを起動する
  - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)をダウンロードし、インストールする
  - [Vagrant](https://www.vagrantup.com/downloads)をダウンロードし、インストールする

### コンテナの起動

- `docker compose`を使う場合
  ```sh
  $ cd docker
  $ docker compose up
  ```
- `docker-compose`を使う場合
  ```sh
  $ cd docker
  $ docker-compose up
  ```
- Vagrant & VirtualBoxを使う場合
  ```sh
  $ vagrant up
  ```

### Jupyter notebookへのアクセス

- Webブラウザで[http://localhost:8888](http://localhost:8888)を開く
  - `notebooks`ディレクトリを開く
- ファイルの実体はローカルの[`notebooks`](./notebooks)ディレクトリに存在する


## Contributing guide

- Notebookの変更をコミットする前に、下の画像のようにnotebookのツールバーの`Kernel` > `Restart & Clear Output`を実行した上で保存しておくこと
  - 演習のために、コードの実行結果を消しておくため
  - 本質的でないメタデータの差分が混じることを防ぐため
  ![todo before commit](todo_before_commit.png)
