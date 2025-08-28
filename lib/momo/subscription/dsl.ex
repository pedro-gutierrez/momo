defmodule Momo.Subscription.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    tags: [Momo.Subscription.Dsl.Subscription]
end
