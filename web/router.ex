defmodule IotIntern.Router do
  use Antikythera.Router

  static_prefix "/ui"

  post "/api/v1/alert", Alert, :post_alert
end
