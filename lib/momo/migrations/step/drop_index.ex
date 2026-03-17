defmodule Momo.Migrations.Step.DropIndex do
  @moduledoc false
  @behaviour Momo.Migrations.Step
  alias Momo.Migrations.{Index, State}

  defstruct [:index]

  @impl true
  def decode({:drop_if_exists, _, [{:index, _, [table, _, opts]}]}) do
    name = Keyword.fetch!(opts, :name)
    index = Index.from_opts(name: name, table: table)

    %__MODULE__{index: index}
  end

  def decode(_), do: nil

  @impl true
  def encode(%__MODULE__{index: index}) do
    opts = [name: index.name]

    {:drop_if_exists, [line: 1], [{:index, [line: 1], [index.table, [], opts]}]}
  end

  @impl true
  def aggregate(%__MODULE__{} = step, state),
    do: State.remove!(state, :indexes, step.index)

  @impl true
  def diff(old_state, new_state) do
    for {index_name, index} <- old_state.indexes do
      if !State.has?(new_state, :indexes, index_name) do
        %__MODULE__{index: index}
      else
        nil
      end
    end
  end
end
