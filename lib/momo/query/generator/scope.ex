defmodule Momo.Query.Generator.Scope do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_query, _opts) do
    quote do
      def scope(context), do: Momo.Query.scope(__MODULE__, context)
    end
  end
end
