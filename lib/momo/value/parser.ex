defmodule Momo.Value.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Value
  alias Momo.Value.Field

  def parse({:value, opts, fields}, _opts) do
    model_fields =
      case opts[:from] do
        nil ->
          []

        model ->
          model.fields()
          |> Map.values()
          |> Enum.reject(&(&1.computation || &1.name in [:inserted_at, :updated_at]))
          |> Enum.map(fn field ->
            %Field{
              name: field.name,
              type: field.kind,
              many: false,
              default: field.default,
              allowed_values: field.in,
              required: field.required?
            }
          end)
      end

    custom_fields =
      for {:field, attrs, _} <- fields do
        %Field{
          name: Keyword.fetch!(attrs, :name),
          type: Keyword.fetch!(attrs, :type),
          many: Keyword.get(attrs, :many, false),
          default: Keyword.get(attrs, :default, nil),
          allowed_values: Keyword.get(attrs, :in, []),
          required: Keyword.get(attrs, :required, true)
        }
      end

    fields = custom_fields ++ model_fields

    %Value{fields: fields}
  end
end
