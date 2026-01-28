defmodule Momo.App.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.App.Dsl.App,
    tags: [
      Momo.App.Dsl.Repos,
      Momo.App.Dsl.Endpoints,
      Momo.App.Dsl.Models,
      Momo.App.Dsl.Commands,
      Momo.App.Dsl.Queries,
      Momo.App.Dsl.Events,
      Momo.App.Dsl.Flows,
      Momo.App.Dsl.Subscriptions,
      Momo.App.Dsl.Mappings,
      Momo.App.Dsl.Values,
      Momo.App.Dsl.Scopes
    ]
end
