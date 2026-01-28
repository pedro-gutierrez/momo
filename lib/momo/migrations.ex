defmodule Momo.Migrations do
  @moduledoc false
  alias Momo.Migrations.Migration
  alias Momo.Migrations.Constraint
  alias Momo.Migrations.Index
  alias Momo.Migrations.State
  alias Momo.Migrations.Table

  def existing(dir) do
    Path.join([dir, "*_momo_*.exs"])
    |> Path.wildcard()
    |> Enum.sort()
    |> Enum.map(&File.read!(&1))
  end

  def missing(existing, app) do
    existing =
      existing
      |> Enum.map(&Code.string_to_quoted!(&1))
      |> Enum.map(&Migration.decode/1)
      |> Enum.reject(& &1.skip)

    new_state = state_from_app(app)
    old_state = state_from_migrations(existing)
    next_version = next_version(existing)

    Migration.diff(old_state, new_state, version: next_version)
  end

  defp state_from_migrations(migrations) do
    migrations
    |> Enum.reject(& &1.skip)
    |> Enum.reduce(State.new(), &Migration.aggregate/2)
  end

  defp state_from_app(app) do
    app.models()
    |> Enum.reject(& &1.virtual?())
    |> Enum.reduce(State.new(), &state_with_model/2)
  end

  defp state_with_model(model, state) do
    state
    |> state_with_table(model)
    |> state_with_constraints(model)
    |> state_with_indexes(model)
  end

  defp state_with_table(state, model) do
    table = Table.from_model(model)
    State.add!(state, nil, :tables, table)
  end

  defp state_with_constraints(state, model) do
    model.parents()
    |> Enum.map(&Constraint.from_relation/1)
    |> Enum.reduce(state, fn constraint, state ->
      State.add!(state, nil, :constraints, constraint)
    end)
  end

  defp state_with_indexes(state, model) do
    model.keys()
    |> Enum.map(&Index.from_key/1)
    |> Enum.reduce(state, fn index, state ->
      State.add!(state, nil, :indexes, index)
    end)
  end

  defp next_version([]), do: 1
  defp next_version(migrations), do: List.last(migrations).version + 1
end
