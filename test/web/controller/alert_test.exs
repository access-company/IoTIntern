defmodule IotIntern.Controller.AlertTest do
  use ExUnit.Case

  alias Antikythera.Httpc
  alias IotIntern.Linkit

  @api_path "/api/v1/alert"

  setup do
    on_exit(&:meck.unload/0)
  end

  test "alert api succeeds with 200" do
    res_body = %{
      "chat_message" => %{
        "_id" => "2456598c88d3fdd8aa000017",
        "chat_room_id" => "33398950c711636832000059",
        "user_id" => "1267712707",
        "type" => "string",
        "post_date" => "2015-07-22T00:57:45Z",
        "msg_seq" => 10230,
        "request_id" => "d80979c1-624c-4b9e-91e3-d1a0a713c7d01437526664419",
        "is_deleted" => false,
        "unread_count" => 1,
        "message" => "脱輪が発生しました"
      }
    }

    now = ~U[2021-06-02T03:53:30Z]
    :meck.expect(DateTime, :utc_now, fn -> now end)

    [
      {"jamming", "異物混入が発生しました"},
      {"derailment", "脱輪が発生しました"},
      {"dead_battery", "バッテリー不足が発生しました"},
    ]
    |> Enum.each(fn {alert_message, linkit_message} ->
      :meck.expect(Linkit, :post_message, fn message ->
        assert message == linkit_message
        {201, put_in(res_body, ["chat_message", "message"], linkit_message)}
      end)

      req_body = %{"type" => alert_message}
      res = Req.post_json(@api_path, req_body, %{})
      assert res.status == 200
      assert Jason.decode!(res.body) == %{"sent_at" => "2021-06-02T03:53:30Z"}
    end)
  end

  test "alert api fails with 400" do
    expected_body = %{"message" => "Unable to understand the request", "type" => "BadRequest"}

    Enum.each(["unexpected", 0], fn message ->
      req_body = %{"type" => message}
      res = Req.post_json(@api_path, req_body, %{})
      assert res.status == 400
      assert Jason.decode!(res.body) == expected_body
    end)
  end

  test "alert api fails with 500 due to status 404 of Linkit API" do
    :meck.expect(Httpc, :post, 3, {:ok, %{status: 404}})

    expected_body = %{"message" => "Error caused on Linkit", "type" => "LinkitError"}

    req_body = %{"type" => "jamming"}
    res = Req.post_json(@api_path, req_body, %{})
    assert res.status == 500
    assert Jason.decode!(res.body) == expected_body
  end

  test "alert api fails with 500 due to timeout of Linkit API" do
    :meck.expect(Httpc, :post, 3, {:error, :timeout})

    expected_body = %{"message" => "Error caused on Linkit", "type" => "LinkitError"}

    req_body = %{"type" => "jamming"}
    res = Req.post_json(@api_path, req_body, %{})
    assert res.status == 500
    assert Jason.decode!(res.body) == expected_body
  end
end
