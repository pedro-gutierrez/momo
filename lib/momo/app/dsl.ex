defmodule Momo.App.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.App.Dsl.App,
    tags: [
      Momo.App.Dsl.Repos,
      Momo.App.Dsl.Endpoints,
      Momo.App.Dsl.Features
    ]
end
