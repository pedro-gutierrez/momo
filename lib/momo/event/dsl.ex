defmodule Momo.Event.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Event.Dsl.Event,
    tags: [
      Momo.Event.Dsl.Field
    ]
end
