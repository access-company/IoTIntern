defmodule IotIntern.Controller.Hello do
  use Antikythera.Controller

  alias Antikythera.Conn

  def hello(%{request: req} = conn) do
    %{
      headers: %{
        "auth" => auth,
      },
      body: %{
        "message" => msg,
      },
    } = req

    if auth == "xxxx" and msg == "hello" do
      Conn.json(conn, 200, %{"message" => "ok"})
    else
      Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
