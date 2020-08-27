defmodule IotIntern.Controller.HelloCroma do
  use Antikythera.Controller

  alias Antikythera.Conn

  defmodule RequestBody do
    use Croma

    defmodule Message do
      use Croma.SubtypeOfAtom, values: [:hello, :world]
    end

    use Croma.Struct, recursive_new?: true, fields: [
      message: Message,
    ]
  end

  def hello(%{request: %{body: req_body}} = conn) do
    case RequestBody.new(req_body) do
      {:ok, _} -> Conn.json(conn, 200, req_body)
      _        -> Conn.json(conn, 400, %{"message" => "ng"})
    end
  end
end
