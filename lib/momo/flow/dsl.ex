defmodule Momo.Flow.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Flow.Dsl.Flow,
    tags: [
      Momo.Flow.Dsl.Steps
    ]
end
