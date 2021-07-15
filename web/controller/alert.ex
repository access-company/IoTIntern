defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  # 必要に応じて適宜エイリアスのコメントアウトを解除してください
  # alias IotIntern.Error
  # alias IotIntern.Linkit

  def post_alert(%{request: %{body: _body}} = conn) do
    iso_now_time = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
    Conn.json(conn, 200, %{sent_at: iso_now_time})
  end
end
