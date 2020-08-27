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

    case {auth, msg} do
      {"xxxx", msg} when msg in ["hello", "world"] -> Conn.json(conn, 200, req_body)
      _                                            -> Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
