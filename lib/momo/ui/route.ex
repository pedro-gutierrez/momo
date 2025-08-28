defmodule Momo.Ui.Route do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Ui.Route.Dsl,
    generators: [
      Momo.Ui.Route.Generator.Handler,
      Momo.Ui.Route.Generator.Metadata
    ]

  defstruct [:path, :method, :action, :views]
end
