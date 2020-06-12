defmodule IotIntern.Controller.Hello do
  use Antikythera.Controller

  def hello(conn) do
    IotIntern.Gettext.put_locale(conn.request.query_params["locale"] || "en")
    Conn.render(conn, 200, "hello", [gear_name: :iot_intern])
  end
end
