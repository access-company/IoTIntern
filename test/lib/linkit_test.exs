defmodule IotIntern.Controller.LinkitTest do
  use ExUnit.Case

  alias Antikythera.Httpc
  alias IotIntern.Linkit

  setup do
    on_exit(&:meck.unload/0)
  end

  test "Linkit.post_message returns 201" do
    :meck.expect(Httpc, :post, 3, {:ok, %{status: 201}})

    assert Linkit.post_message("message") == {201, nil}
  end

  test "Linkit.post_message returns 500" do
    res_body = """
    {
      "result": "failed",
      "error_code": 40301,
      "error_message": "chat room members limit exceeded"
    }
    """

    :meck.expect(Httpc, :post, 3, {:ok, %{status: 403, body: res_body}})

    expected = %{
      "error_code" => 40301,
      "error_message" => "chat room members limit exceeded",
      "result" => "failed"
    }

    assert Linkit.post_message("message") == {403, expected}
  end

  test "Linkit.post_message returns error with timeout" do
    :meck.expect(Httpc, :post, 3, {:error, :timeout})

    assert Linkit.post_message("message") == {:error, :timeout}
  end
end
