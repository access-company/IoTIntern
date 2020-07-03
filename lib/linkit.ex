defmodule IotIntern.Linkit do
  alias Antikythera.Httpc

  @linkit_base_url  "https://linkit-api.jin-soku.biz"

  def post_message(message) do
    http_headers = %{
      "Content-Type"  => "application/json",
      "x-api-key"     => IotIntern.get_env("linkit_api_key"),
      "Authorization" => IotIntern.get_env("notification_user_credential")
    }
    req_body = %{
      type:    "string",
      message: message
    }
    
    generate_request_url()
    |> send_request_to_linkit(req_body, http_headers)
  end

  defp generate_request_url() do
    %{
      "linkit_app_id"   => linkit_app_id,
      "linkit_group_id" => linkit_group_id,
      "chatroom_id"     => chatroom_id
    } = IotIntern.get_all_env()

    @linkit_base_url <> "/#{linkit_app_id}/#{linkit_group_id}/chat_rooms/#{chatroom_id}/messages"
  end

  defp send_request_to_linkit(url, body, header) do
    case Httpc.post(url, {:json, body}, header) do
      {:ok, %{status: 201, body: body}} -> {:ok,    decode_success_response(body)}
      {:ok, %{body: body}}              -> {:error, decode_error_response(body)  }
    end
  end

  defp decode_success_response(body) do
    %{
      "chat_message" => %{
        "message"   => message,
        "post_date" => post_date
      }
    } = Jason.decode!(body)
    %{message: message, post_date: post_date}
  end

  defp decode_error_response(body) do
    case Jason.decode(body) do
      {:ok, decoded_body} ->
        decoded_body
      {:error, _} ->
        :linkit_error
    end
  end
end
