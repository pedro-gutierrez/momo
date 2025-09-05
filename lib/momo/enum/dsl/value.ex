defmodule Momo.Enum.Dsl.Value do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :name, kind: :any, required: true
    attribute :label, kind: :string, required: true
  end
end
