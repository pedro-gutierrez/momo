defprotocol Momo.Maps.StringKeys do
  @fallback_to_any true
  def to_string_keys(data)
end

defimpl Momo.Maps.StringKeys, for: [Date, DateTime, NaiveDateTime, Time] do
  def to_string_keys(data), do: data
end

defimpl Momo.Maps.StringKeys, for: List do
  def to_string_keys(list) do
    Enum.map(list, &Momo.Maps.StringKeys.to_string_keys/1)
  end
end

defimpl Momo.Maps.StringKeys, for: Map do
  def to_string_keys(map) do
    case Momo.Maps.Plain.to_plain_map(map) do
      nil ->
        nil

      plain_map when is_map(plain_map) ->
        plain_map
        |> Enum.map(fn {key, value} ->
          {to_string(key), Momo.Maps.StringKeys.to_string_keys(value)}
        end)
        |> Enum.reject(fn {_key, value} -> is_nil(value) end)
        |> Enum.into(%{})

      other ->
        Momo.Maps.StringKeys.to_string_keys(other)
    end
  end
end

defimpl Momo.Maps.StringKeys, for: Ecto.Association.NotLoaded do
  def to_string_keys(_), do: nil
end

defimpl Momo.Maps.StringKeys, for: Any do
  def to_string_keys(data) when is_struct(data) do
    case Momo.Maps.Plain.to_plain_map(data) do
      nil -> nil
      plain_data -> Momo.Maps.StringKeys.to_string_keys(plain_data)
    end
  end

  def to_string_keys(data), do: data
end
