defmodule IotIntern.Linkit do
  alias Antikythera.Httpc

  @linkit_base_url  "https://linkit-api.jin-soku.biz"

  # typespec に定義される関数仕様となるように関数を実装してください。
  # typespec (https://hexdocs.pm/elixir/1.12/typespecs.html) とは関数の型仕様を宣言するための仕様で、下記のような記法で記述します。
  # @spec 関数名(引数の型,..) :: 返り値の型
  # つまり、post_message は String.t を引数にとり、返り値として2種類の型のタプルを返すという仕様になっています。
  # post_message 関数の引数と返り値の具体例としては test/lib/linkit_test.exs を参照ください。
  @spec post_message(String.t) :: {integer, map} | {:error, any}
  def post_message(message) do
    %{
      "linkit_api_key"               => api_key,
      "notification_user_credential" => credential,
      "linkit_app_id"                => app_id,
      "linkit_group_id"              => group_id,
      "chatroom_id"                  => chatroom_id,
    } = IotIntern.get_all_env()

    # 適切なリクエスト URL を作ってください
    endpoint_url = Enum.join([
      @linkit_base_url,
      app_id,
      group_id,
      "chat_rooms",
      chatroom_id,
      "messages"
    ], "/")

    # 適切な HTTP ヘッダを作ってください
    header = %{
      "authorization" => credential,
      "x-api-key"     => api_key,
    }

    # 適切なリクエストボディを作ってください
    req_body = %{
      "type"    => "string",
      "message" => message,
    }

    # 仕様に沿った関数の戻り値を返せるように実装してください
    case Httpc.post(endpoint_url, {:json, req_body}, header) do
      {:ok, %{status: 201, body: res_body}} -> {201, Jason.decode!(res_body)}
      {:ok, %{status: 403, body: res_body}} -> {403, Jason.decode!(res_body)}
      {:error, reason} -> {:error, reason}
    end
  end
end
