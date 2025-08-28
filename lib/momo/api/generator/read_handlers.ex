defmodule Momo.Api.Generator.ReadHandlers do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(api, _) do
    for feature <- api.features, model <- feature.models(), %{name: :read} <- model.actions() do
      handler_module = Module.concat(model, ApiReadHandler)
      decoder_module = Module.concat(model, ApiReadDecoder)

      feature_fun = String.to_atom("read_#{model.name()}")

      quote do
        defmodule unquote(handler_module) do
          use Plug.Builder

          import Momo.Api.ConnHelper
          import Momo.Api.ErrorEncoder
          import Momo.Api.Encoder

          import unquote(decoder_module)

          plug(:execute)

          def execute(conn, _opts) do
            with {:ok, params} <- decode(conn.params),
                 params <- Map.merge(params, conn.assigns),
                 {:ok, model} <-
                   unquote(feature).unquote(feature_fun)(params.id, params) do
              model
              |> encode()
              |> send_json(conn)
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
end
