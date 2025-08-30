defmodule Momo.Model.Generator.PlainMap do
  @moduledoc false

  @behaviour Diesel.Generator
  def generate(_model, _) do
    quote do
      def plain_map(%__MODULE__{} = model),
        do: Momo.Maps.string_keys(model)
    end
  end
end
