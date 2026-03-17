defmodule Momo.Migrations.Step.CreateConstraint do
  @moduledoc false
  @behaviour Momo.Migrations.Step

  alias Momo.Migrations.{Constraint, State}

  defstruct [:constraint]

  @impl true
  def decode(
        {:alter, _,
         [
           {:table, _, [table]},
           [do: {:modify, _, [column, {:references, _, [other, opts]}]}]
         ]}
      ) do
    constraint =
      opts
      |> Keyword.merge(table: table, column: column, target: other)
      |> Constraint.new()

    %__MODULE__{constraint: constraint}
  end

  def decode(_), do: nil

  @impl true
  def encode(step) do
    {:alter, [line: 1],
     [
       {:table, [line: 1], [step.constraint.table]},
       [
         do:
           {:modify, [line: 1],
            [
              step.constraint.column,
              {:references, [line: 1],
               [
                 step.constraint.target,
                 [
                   type: step.constraint.type,
                   on_delete: step.constraint.on_delete
                 ]
               ]}
            ]}
       ]
     ]}
  end

  @impl true
  def aggregate(step, state),
    do: State.add!(state, :constraints, step.constraint)

  @impl true
  def diff(old_state, new_state) do
    for {constraint_name, constraint} <- new_state.constraints do
      if !State.has?(old_state, :constraints, constraint_name) do
        %__MODULE__{constraint: constraint}
      else
        nil
      end
    end
  end
end
