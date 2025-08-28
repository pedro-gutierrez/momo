defmodule Momo.Command.Generator.Execute do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_command, _opts) do
    quote do
      def execute(params, context \\ %{}), do: Momo.Command.execute(__MODULE__, params, context)
    end
  end
end
