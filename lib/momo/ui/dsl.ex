defmodule Momo.Ui.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Ui.Dsl.Ui,
    tags: [
      Momo.Ui.Dsl.Namespaces
    ]
end
