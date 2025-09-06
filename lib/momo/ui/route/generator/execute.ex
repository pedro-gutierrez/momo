defmodule Momo.Ui.Route.Generator.Execute do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_route, _opts) do
    quote do
      def execute(params), do: params

      defoverridable execute: 1
    end
  end
end
