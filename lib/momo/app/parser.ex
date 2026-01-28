defmodule Momo.App.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.App

  @impl true
  def parse({:app, attrs, children}, opts) do
    caller_module = Keyword.fetch!(opts, :caller_module)

    roles =
      attrs
      |> Keyword.fetch!(:roles)
      |> String.split(".")
      |> Enum.map(&String.to_atom/1)

    repos = for {:repos, _, repos} <- children, do: repos
    endpoints = for {:endpoints, _, endpoints} <- children, do: endpoints
    models = for {:models, _, models} <- children, do: models
    commands = for {:commands, _, commands} <- children, do: commands
    queries = for {:queries, _, queries} <- children, do: queries
    events = for {:events, _, events} <- children, do: events
    flows = for {:flows, _, flows} <- children, do: flows
    subscriptions = for {:subscriptions, _, subscriptions} <- children, do: subscriptions
    mappings = for {:mappings, _, mappings} <- children, do: mappings
    values = for {:values, _, values} <- children, do: values
    scopes = for {:scopes, _, scopes} <- children, do: scopes

    repos = List.flatten(repos)
    endpoints = List.flatten(endpoints)

    name = caller_module |> Module.split() |> Enum.drop(-1) |> Module.concat()

    repos = if repos == [], do: [Module.concat(name, Repo)], else: repos
    endpoints = if endpoints == [], do: [Module.concat(name, Endpoint)], else: endpoints

    %App{
      name: name,
      roles: roles,
      module: caller_module,
      repos: repos,
      endpoints: endpoints,
      models: List.flatten(models),
      commands: List.flatten(commands),
      queries: List.flatten(queries),
      events: List.flatten(events),
      flows: List.flatten(flows),
      subscriptions: List.flatten(subscriptions),
      mappings: List.flatten(mappings),
      values: List.flatten(values),
      scopes: List.flatten(scopes)
    }
  end
end
