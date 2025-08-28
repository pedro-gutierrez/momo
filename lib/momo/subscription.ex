defmodule Momo.Subscription do
  @moduledoc """
  A DSL to define event subscriptions and their associated command handlers
  """

  use Diesel,
    otp_app: :momo,
    dsl: Momo.Subscription.Dsl,
    parser: Momo.Subscription.Parser,
    generators: [
      Momo.Subscription.Generator.Metadata,
      Momo.Subscription.Generator.Execute
    ]

  defstruct [:name, :feature, :event, :action]

  def execute(subscription, params) do
    params = Map.from_struct(params)
    feature = subscription.feature()
    fun = subscription.action().fun_name()

    apply(feature, fun, [params])
  end
end
