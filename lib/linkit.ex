defmodule IotIntern.Linkit do
  alias Antikythera.Httpc

  @linkit_base_url  "https://linkit-api.jin-soku.biz"

  def post_message(message) do
    %{
      "linkit_api_key"               => api_key,
      "notification_user_credential" => credential,
      "linkit_app_id"                => app_id,
      "linkit_group_id"              => group_id,
      "chatroom_id"                  => chatroom_id,
    } = IotIntern.get_all_env()

    endpoint_url = Enum.join([
      @linkit_base_url,
      app_id,
      group_id,
      "chat_rooms",
      chatroom_id,
      "messages"
    ], "/")

    header = %{
      "authorization" => credential,
      "x-api-key"     => api_key,
    }

    req_body = %{
      "type"    => "string",
      "message" => message,
    }

    case Httpc.post(endpoint_url, {:json, req_body}, header) do
      {:ok, %{status: 201}} -> {201, nil}
      {:ok, %{status: 403, body: res_body}} -> {500, Jason.decode!(res_body)}
      {:error, :timeout} -> {:error, :timeout}
    end
  end
end
