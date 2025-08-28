defmodule Momo.Ui.Route.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Ui.Route.Dsl.Route,
    tags: [
      Momo.Ui.Route.Dsl.View
    ]
end
