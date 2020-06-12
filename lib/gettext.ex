use Croma

defmodule IotIntern.Gettext do
  use Antikythera.Gettext, otp_app: :iot_intern

  defun put_locale(locale :: v[String.t]) :: nil do
    Gettext.put_locale(__MODULE__, locale)
  end
end
