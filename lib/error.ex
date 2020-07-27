defmodule IotIntern.Error do
  def bad_request_error() do
    %{
      type:    "BadRequest",
      message: "Unable to understand the request"
    }
  end

  def linkit_error() do
    %{
      type:    "LinkitError"
      message: "Error caused on Linkit"
    }
  end
end