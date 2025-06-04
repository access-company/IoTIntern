defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  # 必要に応じて適宜エイリアスのコメントアウトを解除してください
  alias IotIntern.Error
  alias IotIntern.Linkit

  @alert_messages %{
    "dead_battery" => "バッテリー不足",
    "derailment" => "脱輪",
    "jamming" => "異物混入"
  }

  def post_alert(%{request: %{body: body}} = conn) do
    if body["type"] in ["dead_battery", "derailment", "jamming"] do
      message = Map.get(@alert_messages, body["type"])

      case Linkit.post_message(message) do
        {201, _} ->
          iso_now_time = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
          Conn.json(conn, 200, %{sent_at: iso_now_time})

        _ ->
          Conn.json(conn, 500, Error.linkit_error())
      end
    else
      Conn.json(conn, 400, Error.bad_request_error())
    end
  end
end
