defmodule Momo.Value.Dsl.Value do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :from, kind: :module, required: false
    child :field, min: 0
  end
end
