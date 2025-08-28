defmodule Momo.Feature.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Feature.Dsl.Feature,
    tags: [
      Momo.Feature.Dsl.Commands,
      Momo.Feature.Dsl.Handlers,
      Momo.Feature.Dsl.Models,
      Momo.Feature.Dsl.Queries,
      Momo.Feature.Dsl.Scopes,
      Momo.Feature.Dsl.Events,
      Momo.Feature.Dsl.Subscriptions,
      Momo.Feature.Dsl.Flows,
      Momo.Feature.Dsl.Mappings
    ]
end
