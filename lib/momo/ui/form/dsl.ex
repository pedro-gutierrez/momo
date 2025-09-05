defmodule Momo.Ui.Form.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Ui.Form.Dsl.Form,
    tags: []
end
