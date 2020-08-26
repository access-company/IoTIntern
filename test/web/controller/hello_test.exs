defmodule IotIntern.Controller.HelloTest do
  use ExUnit.Case

  alias Antikythera.Httpc

  @api_path "/api/v1/hello"

  test "hello api succeeds with 200" do
    # NOTE: モジュール名、関数名、引数の数, 任意の返り値
    :meck.expect(Httpc, :get, 1, :ok)

    headers = %{"auth" => "xxxx"}
    Enum.each(["hello", "world"], fn message ->
      req_body = %{"message" => message}
      res = Req.post_json(@api_path, req_body, headers)
      assert res.status == 200
      assert Jason.decode!(res.body) == %{"message" => message}
    end)
    :meck.unload()
  end

  test "hello api fails with 400" do
    :meck.expect(Httpc, :get, 1, :ok)
    headers = %{"auth" => "xxxx"}
    req_body = %{"message" => "Invalid Message"}
    res = Req.post_json(@api_path, req_body, headers)
    assert res.status == 400
    assert Jason.decode!(res.body) == %{"message" => "ng"}
    :meck.unload()
  end

  test "hello-croma api succeeds with 200" do
    headers = %{"auth" => "xxxx"}
    req_body = %{"message" => "hello"}
    res = Req.post_json("/api/v1/hello-croma", req_body, headers)
    assert res.status == 200
    assert Jason.decode!(res.body) == %{"message" => "hello"}
  end

  test "hello-croma api fails with 400" do
    headers = %{"auth" => "xxxx"}
    req_body = %{"message" => "Invalid Message"}
    res = Req.post_json("/api/v1/hello-croma", req_body, headers)
    assert res.status == 400
    assert Jason.decode!(res.body) == %{"message" => "ng"}
  end
end
