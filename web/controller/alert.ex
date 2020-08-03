# 課題1
#   以下のコードは空のレスポンスをステータス200で返すようになっています．
#   仕様にそったレスポンスの一例を返すようにAPIを実装してください．
#   （この課題ではリクエストに応じてレスポンスを変える必要はありません）
#
# 課題2
#   課題1を元に，リクエストボディに応じてレスポンスが変わるように実装を変更してください．
#   ただし，8行目から11行目のコメントアウトを解除して用いること．
#   ヒント：リクエストボディは%{body: _body}を%{body: body}とするとbodyをコードで利用することが出来ます
#
# 課題3
#   lib/linkit.exにLinkitのAPIを叩くための関数があります．
#   コメントアウトを解除し，適宜コードを保管して関数を完成させて，Linkitへ通知が送れるようにしてください．
#
# 課題4
#   テストコードの課題を出す予定（TBD）
#
# 課題5
#   新規のAPIを課題として出す予定（TBD）
#
# 課題6
#   Cromaによるバリデーションを課題として出す予定（TBD）

defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  # 必要に応じて適宜エイリアスのコメントアウトを解除してください
  # alias IotIntern.Error
  # alias IotIntern.Linkit

  # アトリビュートのMapの中は好きに変更して構いません．
  # @alert_messages %{
  #   "dead_battery" => "バッテリー不足",
  #   "derailment"   => "脱輪",
  #   "jamming"      => "異物混入"
  # }

  def post_alert(%{request: %{body: _body}} = conn) do
    Conn.json(conn, 200, %{})
  end
end
