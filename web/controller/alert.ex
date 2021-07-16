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
#   mix test test/lib/linkit_test.exs を実行してテストが成功することを確認してください.
#
# 課題4
#   Alert APIのテストコードを書いてみてください.
#
# 課題5 (Optional)
#   Cromaを用いてリクエストボディのバリデーションを試してみてください.

defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  # 必要に応じて適宜エイリアスのコメントアウトを解除してください
  alias IotIntern.Error
  # alias IotIntern.Linkit

  @alert_messages %{
    "dead_battery" => "バッテリー不足",
    "derailment"   => "脱輪",
    "jamming"      => "異物混入"
  }

  def post_alert(%{request: %{body: body}} = conn) do
    case validate_request_body(body) do
      {:ok, _validated} ->
        iso_now_time = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
        Conn.json(conn, 200, %{sent_at: iso_now_time})
      {:error, :bad_request} ->
        Conn.json(conn, 400, Error.bad_request_error())
    end
  end

  defp validate_request_body(%{"type" => type} = body) do
    if Map.has_key?(@alert_messages, type), do: {:ok, body}, else: {:error, :bad_request}
  end
  defp validate_request_body(_), do: {:error, :bad_request}
end
