defmodule Momo.Query.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Query.Dsl.Query,
    tags: [
      Momo.Query.Dsl.Policy,
      Momo.Query.Dsl.Sort
    ]
end
