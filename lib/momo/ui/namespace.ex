defmodule Momo.Ui.Namespace do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Ui.Namespace.Dsl,
    generators: [
      Momo.Ui.Namespace.Generator.Metadata,
      Momo.Ui.Namespace.Generator.Router
    ]

  defstruct [:path, :routes]
end
