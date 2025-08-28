defmodule Momo.Compare do
  @moduledoc false

  @comparators (for op <- [:eq, :neq], into: %{} do
                  {op, Module.concat(__MODULE__, op |> to_string() |> Macro.camelize())}
                end)

  def compare(op, args) do
    compator = Map.fetch!(@comparators, op)
    compator.compare(args)
  end
end
