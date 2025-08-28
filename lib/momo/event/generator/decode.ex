defmodule Momo.Event.Generator.Decode do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_event, _opts) do
    quote do
      def decode(json), do: Momo.Event.decode(__MODULE__, json)
    end
  end
end
