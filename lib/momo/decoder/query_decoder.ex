defmodule Momo.Decoder.QueryDecoder do
  @moduledoc """
  A generic validator that parses model queries as hashmaps, using a dsl
  """

  defmacro __using__(opts) do
    model = Keyword.fetch!(opts, :model)
    attrs = model.attributes() |> Enum.reject(&(&1.name in [:id, :inserted_at, :updated_at]))
    rules = for attr <- attrs, into: %{}, do: {to_string(attr.name), attr_rule(attr)}

    quote do
      use Momo.Decoder.PairsDecoder,
        rules: unquote(rules)
    end
  end

  alias Momo.Decoder.BooleanDecoder

  defp attr_rule(attr) do
    case attr.kind do
      :boolean ->
        [
          required: false,
          nullable: true,
          type: :string,
          custom: &BooleanDecoder.decode/1
        ]

      kind ->
        [required: false, nullable: true, type: :string, cast: kind]
    end
  end
end
