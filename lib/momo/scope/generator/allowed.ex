defmodule Momo.Scope.Generator.Allowed do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_, _opts) do
    quote do
      def allowed?(context), do: Momo.Scope.evaluate(__MODULE__, context) == true
    end
  end
end
