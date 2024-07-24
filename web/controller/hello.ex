# NOTE: curlからの実行方法
# curl -X POST "http://iot-intern.localhost:8080/api/v1/hello" -H 'auth: xxxx' -H 'Content-Type: application/json' -d '{"message": "hello"}'

defmodule IotIntern.Controller.Hello do
  use Antikythera.Controller

  alias Antikythera.Conn
  # alias Antikythera.Httpc

  def hello(%{request: req} = conn) do
    %{
      headers: %{
        "auth" => auth,
      },
      body: %{
        "message" => msg,
      } = req_body,
    } = req

    # NOTE: リクエストの呼び出しは下記のように行うがテストでは実際にリクエストを行わないよう :meck を使う。
    # Httpc.get("https://example.com")

    case {auth, msg} do
      {"xxxx", msg} when msg in ["hello", "world"] -> Conn.json(conn, 200, req_body)
      _                                            -> Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
