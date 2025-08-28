defmodule Momo.Api.Generator.CreateHandlers do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(api, _) do
    for feature <- api.features, model <- feature.models(), %{name: :create} <- model.actions() do
      handler_module(feature, model)
    end
  end

  defp handler_module(feature, model) do
    handler_module = Module.concat(model, ApiCreateHandler)
    decoder_module = Module.concat(model, ApiCreateDecoder)

    create_fun = String.to_atom("create_#{model.name()}")

    quote do
      defmodule unquote(handler_module) do
        use Plug.Builder

        import Momo.Api.ConnHelper
        import Momo.Api.Encoder
        import Momo.Api.ErrorEncoder

        import unquote(decoder_module)

        plug(:execute)

        def execute(conn, _opts) do
          with {:ok, params} <- decode(conn.params),
               {:ok, model} <- unquote(feature).unquote(create_fun)(params, conn.assigns) do
            model
            |> encode()
            |> send_json(conn, status: 201)
          else
            {:error, errors} ->
              errors
              |> encode_errors()
              |> send_json(conn)
          end
        end
      end
    end
  end
end
