defmodule Momo.Enum.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Enum.Dsl.Enum,
    tags: [
      Momo.Enum.Dsl.Value
    ]
end
