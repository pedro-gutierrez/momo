defmodule Momo.Api.Generator.DeleteDecoders do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(api, _) do
    for feature <- api.features, model <- feature.models(), %{name: :delete} <- model.actions() do
      module_name = Module.concat(model, ApiDeleteDecoder)

      rules = %{
        "id" => [required: true, type: :string, uuid: true]
      }

      quote do
        defmodule unquote(module_name) do
          use Momo.Decoder,
            rules: unquote(Macro.escape(rules)),
            mappings: unquote(%{id: ["id"]})
        end
      end
    end
  end
end
