defmodule Momo.Api.Generator.IncludeDecoders do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(api, _) do
    for feature <- api.features, model <- feature.models() do
      module_name = Module.concat(model, ApiIncludeDecoder)

      quote do
        defmodule unquote(module_name) do
          use Momo.Decoder.IncludeDecoder,
            feature: unquote(feature),
            model: unquote(model)
        end
      end
    end
  end
end
