defmodule Momo.Command.Generator.Allow do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_command, _opts) do
    quote do
      def allowed?(context), do: Momo.Command.allowed?(__MODULE__, context)
    end
  end
end
