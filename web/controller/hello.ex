defmodule IotIntern.Controller.Hello do
  use Antikythera.Controller

  alias Antikythera.{Conn, Httpc}

  def hello(%{request: req} = conn) do
    %{
      headers: %{
        "auth" => auth,
      },
      body: %{
        "message" => msg,
      } = req_body,
    } = req

    # NOTE: モックして ok を返すようにする
    :ok = Httpc.get("https://example.com")

    if auth == "xxxx" and (msg == "hello" or msg == "world") do
      Conn.json(conn, 200, req_body)
    else
      Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
