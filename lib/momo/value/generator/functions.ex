defmodule Momo.Value.Generator.Functions do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl Diesel.Generator
  def generate(value, _opts) do
    ecto_schema = Momo.Value.schema(value)

    quote do
      unquote(ecto_schema)

      def changeset(params), do: Momo.Value.changeset(__MODULE__, params)
      def decode(json), do: Momo.Value.decode(__MODULE__, json)
      def new(params), do: Momo.Value.new(__MODULE__, params)
      def validate(params), do: Momo.Value.validate(__MODULE__, params)
    end
  end
end
