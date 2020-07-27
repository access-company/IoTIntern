defmodule IotIntern.Router do
  use Antikythera.Router

  post "/api/v1/alert", Alert, :post_alert
end
