defmodule Momo.Migrations.Step.DropConstraint do
  @moduledoc false
  @behaviour Momo.Migrations.Step

  alias Momo.Migrations.{Constraint, State}

  defstruct [:constraint]

  @impl true
  def decode({:drop_if_exists, _, [{:constraint, _, [table, name]}]}) do
    constraint = Constraint.new(name: name, table: table)

    %__MODULE__{constraint: constraint}
  end

  def decode(_), do: nil

  @impl true
  def encode(step) do
    {:drop_if_exists, [line: 1],
     [{:constraint, [line: 1], [step.constraint.table, step.constraint.name]}]}
  end

  @impl true
  def aggregate(step, state),
    do: State.remove!(state, :constraints, step.constraint)

  @impl true
  def diff(old_state, new_state) do
    for {constraint_name, constraint} <- old_state.constraints do
      if !State.has?(new_state, :constraints, constraint_name) do
        %__MODULE__{constraint: constraint}
      else
        nil
      end
    end
  end
end
