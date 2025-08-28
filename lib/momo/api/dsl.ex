defmodule Momo.Api.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Api.Dsl.Api,
    tags: [
      Momo.Api.Dsl.Features,
      Momo.Api.Dsl.Plugs
    ]
end
