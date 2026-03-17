defmodule Momo.Model.Helpers do
  @moduledoc false

  import Ecto.Changeset

  def atom_keys(map) when is_map(map) do
    map
    |> Enum.map(fn
      {key, value} when is_atom(key) -> {key, value}
      {key, value} when is_binary(key) -> {String.to_existing_atom(key), value}
    end)
    |> Enum.into(%{})
  end

  def validate_uuid(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      case Ecto.UUID.cast(value) do
        {:ok, _} -> []
        :error -> [{field, "is not a valid UUID"}]
      end
    end)
  end

  def maybe_add_id(changeset) do
    if changed?(changeset, :id) do
      changeset
    else
      Ecto.Changeset.put_change(changeset, :id, Ecto.UUID.generate())
    end
  end

  def maybe_add_inserted_at(changeset) do
    if changed?(changeset, :inserted_at) do
      changeset
    else
      now = DateTime.utc_now()
      Ecto.Changeset.put_change(changeset, :inserted_at, now)
    end
  end

  def maybe_add_updated_at(changeset) do
    if changed?(changeset, :updated_at) do
      changeset
    else
      now = DateTime.utc_now()
      Ecto.Changeset.put_change(changeset, :updated_at, now)
    end
  end
end
