defmodule Momo.Enum.Generator.Metadata do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(enum, _opts) do
    quote do
      def enum_values, do: unquote(Macro.escape(enum.values))
      def name, do: unquote(enum.name)
    end
  end
end
