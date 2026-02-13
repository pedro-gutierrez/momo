defmodule Momo.Migrations.Step.CreateTable do
  @moduledoc false
  @behaviour Momo.Migrations.Step

  alias Momo.Migrations.State
  alias Momo.Migrations.Table
  alias Momo.Migrations.Column

  import Momo.Naming

  defstruct [:table]

  @impl true
  def decode({:create, _, [{:table, _, [name, _opts]}, [do: {:__block__, _, columns}]]}) do
    columns = columns |> Column.decode() |> indexed()
    table = %Table{name: name, columns: columns}

    %__MODULE__{table: table}
  end

  def decode({:create, _, [{:table, _, [name, _opts]}, [do: column]]}) do
    columns = indexed([Column.decode(column)])
    table = %Table{name: name, columns: columns}

    %__MODULE__{table: table}
  end

  def decode(_), do: nil

  @impl true
  def encode(%__MODULE__{} = step) do
    opts = [primary_key: false]

    columns =
      step.table.columns
      |> Map.values()
      |> Enum.map(&{:add, [line: 1], Column.encode(&1)})

    columns = columns ++ [{:timestamps, [line: 1], [[type: :utc_datetime_usec]]}]

    {:create, [line: 1],
     [
       {:table, [line: 1], [step.table.name, opts]},
       [
         do: {:__block__, [], columns}
       ]
     ]}
  end

  @impl true
  def aggregate(step, state), do: State.add!(state, :tables, step.table)

  @impl true
  def diff(old_state, new_state) do
    for {table_name, table} <- new_state.tables do
      if !State.has?(old_state, :tables, table_name) do
        %__MODULE__{table: table}
      else
        nil
      end
    end
  end
end
