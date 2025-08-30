defmodule Momo.Maps do
  @moduledoc false

  alias Momo.Maps.Plain
  alias Momo.Maps.StringKeys

  defdelegate plain_map(data), to: Plain, as: :to_plain_map
  defdelegate string_keys(data), to: StringKeys, as: :to_string_keys
end
