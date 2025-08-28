defmodule Momo.Endpoint.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    tags: [
      Momo.Endpoint.Dsl.Mount
    ]
end
