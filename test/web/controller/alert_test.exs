defmodule IotIntern.Controller.AlertTest do
  use ExUnit.Case

  alias Antikythera.Time
  alias Antikythera.Httpc

  @api_path "/api/v1/alert"

  setup do
    on_exit(&:meck.unload/0)
  end

  test "alert api succeeds with 200" do
    :meck.expect(Time, :now, fn() ->
      {Time, {2021, 6, 02}, {3, 53, 30}, 302}
    end)

    :meck.expect(Httpc, :post, 3, {:ok, %{status: 201}})

    Enum.each(["jamming", "derailment", "dead_battery"], fn message ->
      req_body = %{"type" => message}
      res = Req.post_json(@api_path, req_body, %{})
      assert res.status == 200
      assert Jason.decode!(res.body) == %{"sent_at" => "2021-06-02T03:53:30"}
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

  test "alert api fails with 500 due to status 403 of Linkit API" do
    res_body = """
    {
      "result": "failed",
      "error_code": 40301,
      "error_message": "chat room members limit exceeded"
    }
    """

    :meck.expect(Httpc, :post, 3, {:ok, %{status: 403, body: res_body}})

    expected_body = %{"message" => "Error caused on Linkit", "type" => "LinkitError"}

    Enum.each(["jamming", "derailment", "dead_battery"], fn message ->
      req_body = %{"type" => message}
      res = Req.post_json(@api_path, req_body, %{})
      assert res.status == 500
      assert Jason.decode!(res.body) == expected_body
    end)
  end

  test "alert api fails with 500 due to timeout of Linkit API" do
    :meck.expect(Httpc, :post, 3, {:error, :timeout})

    expected_body = %{"message" => "Error caused on Linkit", "type" => "LinkitError"}

    Enum.each(["jamming", "derailment", "dead_battery"], fn message ->
      req_body = %{"type" => message}
      res = Req.post_json(@api_path, req_body, %{})
      assert res.status == 500
      assert Jason.decode!(res.body) == expected_body
    end)
  end
end
