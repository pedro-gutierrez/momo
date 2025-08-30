defprotocol Momo.Maps.Plain do
  @fallback_to_any true
  def to_plain_map(data)
end

defimpl Momo.Maps.Plain, for: Map do
  def to_plain_map(map), do: map
end

defimpl Momo.Maps.Plain, for: List do
  def to_plain_map(list) do
    if Keyword.keyword?(list), do: Map.new(list), else: list
  end
end

defimpl Momo.Maps.Plain, for: Ecto.Association.NotLoaded do
  def to_plain_map(_), do: nil
end

defimpl Momo.Maps.Plain, for: Any do
  def to_plain_map(data) when is_struct(data) do
    data
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Enum.reject(fn {_k, v} ->
      match?(%Ecto.Association.NotLoaded{}, v)
    end)
    |> Enum.into(%{})
  end

  def to_plain_map(data), do: data
end
