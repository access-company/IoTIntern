# defmodule IotIntern.Linkit do
#   alias Antikythera.Httpc

#   @linkit_base_url  "https://linkit-api.jin-soku.biz"

#   def post_message(message) do
#     %{"linkit_api_key" => linkit_api_key, "notification_user_credential" => credential} = IotIntern.get_all_env()

#     # 適切なHTTPヘッダとリクエストボディを作ってください
#     http_headers = %{
#     }
#     req_body = %{
#     }
    
#     generate_request_url()
#     |> send_request_to_linkit(req_body, http_headers)
#   end

#   defp generate_request_url() do
#     # 適切なリクエストURLを作ってください
#   end

#   defp send_request_to_linkit(url, body, header) do
#     case Httpc.post(url, {:json, body}, header) do
#       {:ok, %{status: 201, body: body}} -> {:ok,    decode_success_response(body)}
#       {:ok, %{body: body}}              -> {:error, decode_error_response(body)  }
#     end
#   end

#   defp decode_success_response(body) do
#     # APIのレスポンスに必要な部分だけを関数の戻り値として返せるように成形してください
#   end

#   defp decode_error_response(body) do
#     case Jason.decode(body) do
#       {:ok, decoded_body} ->
#         decoded_body
#       {:error, _} ->
#         :linkit_error
#     end
#   end
# end
