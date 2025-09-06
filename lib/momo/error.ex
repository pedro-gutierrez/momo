defmodule Momo.Error do
  @moduledoc """
  Error utilities
  """

  def format(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def format(error) when is_atom(error), do: to_string(error)
  def format(error) when is_binary(error), do: error
  def format(error), do: inspect(error)

  def simple(%Ecto.Changeset{} = changeset) do
    changeset
    |> format()
    |> Enum.map(fn {field, errors} ->
      {to_string(field), Enum.join(errors, ", ")}
    end)
    |> Enum.into(%{})
  end
end
