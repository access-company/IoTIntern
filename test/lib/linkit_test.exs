defmodule IotIntern.Controller.LinkitTest do
  use ExUnit.Case

  alias Antikythera.Httpc
  alias IotIntern.Linkit

  setup do
    on_exit(&:meck.unload/0)
  end

  test "Linkit.post_message returns 201" do
    res_body = """
    {
      "chat_message": {
        "_id": "2456598c88d3fdd8aa000017",
        "chat_room_id": "33398950c711636832000059",
        "is_deleted": false,
        "message": "脱輪が発生しました",
        "msg_seq": 10230,
        "post_date": "2015-07-22T00:57:45Z",
        "request_id": "d80979c1-624c-4b9e-91e3-d1a0a713c7d01437526664419",
        "type": "string",
        "unread_count": 1,
        "user_id": "1267712707"
      },
    }
    """

    :meck.expect(Httpc, :post, 3, {:ok, %{status: 201, body: res_body}})

    expected = Jason.decode!(res_body)

    assert Linkit.post_message("message") == {201, expected}
  end

  test "Linkit.post_message returns 404" do
    :meck.expect(Httpc, :post, 3, {:ok, %{status: 404}})

    assert Linkit.post_message("message") == {404}
  end

  test "Linkit.post_message returns 500" do
    :meck.expect(Httpc, :post, 3, {:ok, %{status: 500}})

    assert Linkit.post_message("message") == {500}
  end

  test "Linkit.post_message returns error with timeout" do
    :meck.expect(Httpc, :post, 3, {:error, :timeout})

    assert Linkit.post_message("message") == {:error, :timeout}
  end
end
