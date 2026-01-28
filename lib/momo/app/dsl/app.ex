defmodule Momo.App.Dsl.App do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :roles, kind: :string, required: true
    child :repos, min: 0, max: 1
    child :endpoints, min: 0, max: 1
    child :models, min: 0, max: 1
    child :commands, min: 0, max: 1
    child :queries, min: 0, max: 1
    child :events, min: 0, max: 1
    child :flows, min: 0, max: 1
    child :subscriptions, min: 0, max: 1
    child :mappings, min: 0, max: 1
    child :values, min: 0, max: 1
    child :scopes, min: 0, max: 1
  end
end
