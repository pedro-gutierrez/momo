defmodule Momo.Api.Generator.UpdateDecoders do
  @moduledoc false
  @behaviour Diesel.Generator

  import Momo.Decoder

  @impl true
  def generate(api, _) do
    for feature <- api.features, model <- feature.models(), %{name: :update} <- model.actions() do
      module_name = Module.concat(model, ApiUpdateDecoder)

      rules = %{"id" => [required: true, type: :string, uuid: true]}

      rules =
        for attr when attr.name not in [:id] <- model.attributes(), into: rules do
          {to_string(attr.name), [] |> optional() |> attribute_type(attr)}
        end

      rules =
        for rel <- model.parents(), into: rules do
          decoder = Module.concat(rel.target.module, ApiRelationDecoder)

          {to_string(rel.name), [] |> optional() |> relation_type(decoder)}
        end

      mappings = default_mappings(model)

      quote do
        defmodule unquote(module_name) do
          use Momo.Decoder,
            rules: unquote(Macro.escape(rules)),
            mappings: unquote(mappings)
        end
      end
    end
  end
end
