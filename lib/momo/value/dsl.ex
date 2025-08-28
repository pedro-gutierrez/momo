defmodule Momo.Value.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Value.Dsl.Value,
    tags: [
      Momo.Value.Dsl.Field
    ]
end
