defmodule Momo.Command.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Command.Dsl.Command,
    tags: [
      Momo.Command.Dsl.Policy,
      Momo.Command.Dsl.Publish
    ]
end
