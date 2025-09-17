defmodule Momo.Command.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Command
  alias Momo.Command.Policy
  alias Momo.Command.Event

  import Momo.Feature.Naming

  def parse({:command, attrs, children}, opts) do
    name = Keyword.fetch!(opts, :caller_module)

    default_title =
      name
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> String.split("_")
      |> Enum.map_join(" ", &String.capitalize/1)

    title = attrs[:title] || default_title

    caller = Keyword.fetch!(opts, :caller_module)
    feature = feature_module(caller)

    params = Keyword.fetch!(attrs, :params)
    returns = attrs[:returns] || params

    policies =
      for {:policy, attrs, _scopes} <- children do
        role = Keyword.fetch!(attrs, :role)
        scope = Keyword.get(attrs, :scope)

        %Policy{role: role, scope: scope}
      end

    policies =
      for policy <- policies, into: %{} do
        {policy.role, policy}
      end

    events =
      for {:publish, attrs, _} <- children do
        module = Keyword.fetch!(attrs, :event)
        source = attrs[:from] || returns
        module_last = module |> Module.split() |> List.last() |> Macro.underscore()
        source_last = source |> Module.split() |> List.last() |> Macro.underscore()
        mapping = Macro.camelize("#{module_last}_from_#{source_last}")
        mapping = Module.concat([feature, "Mappings", mapping])

        if_expr = Keyword.get(attrs, :if)
        unless_expr = Keyword.get(attrs, :unless)

        %Event{
          module: module,
          mapping: mapping,
          source: source,
          if: if_expr,
          unless: unless_expr
        }
      end

    atomic? = Keyword.get(attrs, :atomic, false)

    fun_name =
      caller
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> String.to_atom()

    many = Keyword.get(attrs, :many, false)

    %Command{
      name: name,
      title: title,
      fun_name: fun_name,
      feature: feature,
      params: params,
      returns: returns,
      many: many,
      policies: policies,
      atomic?: atomic?,
      events: events
    }
  end
end
