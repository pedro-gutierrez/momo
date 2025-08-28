defmodule Momo.Endpoint do
  @moduledoc """
  An endpoint wraps a Bandit listener and a router
  """
  use Diesel,
    otp_app: :momo,
    generators: [
      Momo.Endpoint.Generator.Router,
      Momo.Endpoint.Generator.Supervisor
    ]

  defstruct [:mounts]

  defmodule Mount do
    @moduledoc false
    defstruct [:path, :router]
  end
end
