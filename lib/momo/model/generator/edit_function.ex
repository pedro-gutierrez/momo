defmodule Momo.Model.Generator.EditFunction do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(model, _) do
    [
      with_map_args(model),
      with_keyword_args(model)
    ]
  end

  defp with_map_args(model) do
    quote do
      def edit(model, attrs, opts \\ [])

      def edit(model, attrs, opts) when is_map(attrs) do
        model
        |> update_changeset(attrs, opts)
        |> unquote(model.feature).repo().update()
      end
    end
  end

  defp with_keyword_args(_model) do
    quote do
      def edit(model, attrs, opts) when is_list(attrs) do
        attrs = Map.new(attrs)

        edit(model, attrs, opts)
      end
    end
  end
end
