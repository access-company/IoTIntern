defmodule IotIntern.Controller.Alert do
  use Antikythera.Controller

  alias Antikythera.Conn
  alias IotIntern.Error
  alias IotIntern.Linkit

  @alert_messages %{
    "dead_battery" => "バッテリー不足",
    "derailment"   => "脱輪",
    "jamming"      => "異物混入"
  }

  def post_alert(%{request: %{body: body}} = conn) do
    case validate_request_body(body) do
      {:ok, validated} ->
        message = Map.get(@alert_messages, validated["type"])
        case Linkit.post_message(message) do
          {201, _} ->
            iso_now_time = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
            Conn.json(conn, 200, %{sent_at: iso_now_time})
          _ ->
            Conn.json(conn, 500, Error.linkit_error())
        end
      {:error, :bad_request} ->
        Conn.json(conn, 400, Error.bad_request_error())
    end
  end

  defp validate_request_body(%{"type" => type} = body) do
    if Map.has_key?(@alert_messages, type), do: {:ok, body}, else: {:error, :bad_request}
  end
  defp validate_request_body(_), do: {:error, :bad_request}
end
