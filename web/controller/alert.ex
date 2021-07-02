# 課題1
#   以下のコードは空のレスポンスをステータス200で返すようになっています．
#   仕様に沿って時刻を返すようにAPIを実装してください．
#
# 課題2
#   無効なリクエストボディの場合にレスポンス400が返るようにしてください．
#   ヒント：リクエストボディは%{body: _body}を%{body: body}とするとbodyをコードで利用することが出来ます
#
# 課題3
#   lib/linkit.exにLinkitのAPIを叩くための関数があります．
#   コメントアウトを解除し，適宜コードを補完して関数を完成させて，Linkitへ通知が送れるようにしてください．
#
# 課題4
#   テストコードを書いてみてください.
#
# 課題5 (Optional)
#   Cromaによるバリデーション機能を試してみてください.

defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  # 必要に応じて適宜エイリアスのコメントアウトを解除してください
  # alias IotIntern.Error
  # alias IotIntern.Linkit

  def post_alert(%{request: %{body: _body}} = conn) do
    Conn.json(conn, 200, %{})
  end
end
