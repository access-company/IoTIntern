defmodule IotIntern.Controller.HelloTest do
  use ExUnit.Case

  alias Antikythera.Httpc

  @api_path "/api/v1/hello-croma"

  test "hello-croma api succeeds with 200" do
    headers = %{"auth" => "xxxx"}
    req_body = %{"message" => "hello"}
    res = Req.post_json(@api_path, req_body, headers)
    assert res.status == 200
    assert Jason.decode!(res.body) == %{"message" => "hello"}
  end

  test "hello-croma api fails with 400" do
    headers = %{"auth" => "xxxx"}
    req_body = %{"message" => "Invalid Message"}
    res = Req.post_json(@api_path, req_body, headers)
    assert res.status == 400
    assert Jason.decode!(res.body) == %{"message" => "ng"}
  end
end
