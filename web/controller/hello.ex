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
      } = req_body,
    } = req

    if auth == "xxxx" and (msg == "hello" or msg == "world") do
      Conn.json(conn, 200, req_body)
    else
      Conn.json(conn, 400, %{"message" => "ng"})
    end
  end

  defmodule RequestBody do
    use Croma

    defmodule Message do
      use Croma.SubtypeOfAtom, values: [:hello, :world]
    end


    use Croma.Struct, recursive_new?: true, fields: [
      message: Message,
    ]
  end

  def hello_with_croma(%{request: %{body: req_body}} = conn) do
    case RequestBody.new(req_body) do
      {:ok, _} -> Conn.json(conn, 200, req_body)
      _        -> Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
