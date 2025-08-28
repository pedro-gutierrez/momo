defmodule Momo do
  @moduledoc """
  The `Momo` module aggregates and provides common utility functions for handling DSLs (Domain Specific Languages)
  within the Momo application. It collects various DSL modules and offers functions to manage their local functions
  and tags.
  """

  @dsls [
    Momo.Feature.Dsl,
    Momo.Command.Dsl,
    Momo.Model.Dsl,
    Momo.Query.Dsl,
    Momo.Value.Dsl,
    Momo.Mapping.Dsl,
    Momo.Event.Dsl,
    Momo.Api.Dsl,
    Momo.Endpoint.Dsl,
    Momo.Ui.Dsl,
    Momo.Ui.View.Dsl,
    Momo.Ui.Namespace.Dsl,
    Momo.Ui.Route.Dsl
  ]

  @doc """
  Returns a sorted list of local functions without parentheses from all the DSL modules.
  """
  def locals_without_parens,
    do: @dsls |> Enum.flat_map(& &1.locals_without_parens()) |> Enum.uniq() |> Enum.sort()

  @doc """
  Returns a flat list of tags from all the DSL modules.
  """
  def tags, do: Enum.flat_map(@dsls, & &1.tags())
end
