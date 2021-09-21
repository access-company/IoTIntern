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
