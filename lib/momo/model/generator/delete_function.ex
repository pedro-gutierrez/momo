defmodule Momo.Model.Generator.DeleteFunction do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_model, _) do
    quote do
      def delete(model) do
        with {:ok, _} <-
               model
               |> delete_changeset()
               |> __MODULE__.app().repo().delete(),
             do: :ok
      end
    end
  end
end
