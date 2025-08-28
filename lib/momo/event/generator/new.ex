defmodule Momo.Event.Generator.New do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_event, _opts) do
    quote do
      def new(params), do: Momo.Event.new(__MODULE__, params)
    end
  end
end
