defmodule Momo.Migrations.Step.DropTable do
  @moduledoc false
  @behaviour Momo.Migrations.Step

  alias Momo.Migrations.{State, Table}

  defstruct [:table]

  @impl true
  def decode({:drop_if_exists, _, [{:table, _, [name]}]}) do
    table = %Table{name: name}

    %__MODULE__{table: table}
  end

  def decode(_), do: nil

  @impl true
  def encode(%__MODULE__{} = step) do
    {:drop_if_exists, [line: 1],
     [
       {:table, [line: 1], [step.table.name]}
     ]}
  end

  @impl true
  def aggregate(step, state), do: State.remove!(state, :tables, step.table)

  @impl true
  def diff(old_state, new_state) do
    for {table_name, table} <- old_state.tables do
      if !State.has?(new_state, :tables, table_name) do
        %__MODULE__{table: table}
      else
        nil
      end
    end
  end
end
