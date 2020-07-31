defmodule IotIntern.Router do
  use Antikythera.Router

  static_prefix "/assets"

  post "/api/v1/alert", Alert, :post_alert
end
