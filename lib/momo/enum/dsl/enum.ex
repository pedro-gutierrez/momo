defmodule Momo.Enum.Dsl.Enum do
  @moduledoc false
  use Diesel.Tag

  tag do
    child :value, min: 1
  end
end
