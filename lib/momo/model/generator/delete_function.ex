defmodule Momo.Model.Generator.DeleteFunction do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(model, _) do
    quote do
      def delete(model) do
        with {:ok, _} <-
               model
               |> delete_changeset()
               |> unquote(model.feature).repo().delete(),
             do: :ok
      end
    end
  end
end
