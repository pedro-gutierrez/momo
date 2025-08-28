defmodule Momo.App do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.App.Dsl,
    parser: Momo.App.Parser,
    generators: [
      Momo.App.Generator.Migrate,
      Momo.App.Generator.Application,
      Momo.App.Generator.Roles
    ]

  defstruct [:name, :roles, :module, :repos, :endpoints, :features]
end
