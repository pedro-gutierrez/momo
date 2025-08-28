defmodule Momo.Mapping.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Mapping.Dsl.Mapping,
    tags: [
      Momo.Mapping.Dsl.Field
    ]
end
