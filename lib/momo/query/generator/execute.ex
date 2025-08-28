defmodule Momo.Query.Generator.Execute do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_query, _opts) do
    quote do
      def execute(params, context), do: Momo.Query.execute(__MODULE__, params, context)
      def execute(context), do: Momo.Query.execute(__MODULE__, context)
    end
  end
end
