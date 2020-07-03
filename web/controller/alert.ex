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
    case validate_and_convert_request(body) do
      {:ok, message} ->
        Linkit.post_message(message)
      error ->
        error
    end
    |> handle_response(conn)
  end

  defp validate_and_convert_request(req) do
    case req do
      %{"type" => type} ->
        message = Map.get(@alert_messages, type)
        if message == nil do
          {:error, :bad_request}
        else
          {:ok, message}
        end
      _ ->
        {:error, :bad_request}
    end
  end

  def handle_response(result, conn) do
    case result do
      {:ok, body} ->
        Conn.json(conn, 201, body)
      {:error, :bad_request} ->
        Conn.json(conn, 400, Error.bad_request_error())
      {:error, :linkit_error} ->
        Conn.json(conn, 403, Error.linkit_error())
    end
  end
end
