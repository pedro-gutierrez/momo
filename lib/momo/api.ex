defmodule Momo.Api do
  @moduledoc """
  Builds a json api for your feature
  """
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Api.Dsl,
    parsers: [
      Momo.Api.Parser
    ],
    generators: [
      # Momo.Api.Generator.IncludeDecoders,
      # Momo.Api.Generator.QueryDecoders,
      # Momo.Api.Generator.SortDecoders,
      # Momo.Api.Generator.RelationDecoders,
      # Momo.Api.Generator.CreateDecoders,
      # Momo.Api.Generator.UpdateDecoders,
      # Momo.Api.Generator.ReadDecoders,
      # Momo.Api.Generator.ListDecoders,
      # Momo.Api.Generator.ListByParentDecoders,
      # Momo.Api.Generator.DeleteDecoders,
      # Momo.Api.Generator.CreateHandlers,
      # Momo.Api.Generator.UpdateHandlers,
      # Momo.Api.Generator.ReadHandlers,
      # Momo.Api.Generator.ListHandlers,
      # Momo.Api.Generator.ListByParentHandlers,
      # Momo.Api.Generator.DeleteHandlers,
      Momo.Api.Generator.Router
    ]

  defstruct [:features, :plugs]
end
