defmodule Sleeky.Model.Dsl.BelongsTo do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :name, kind: :module, required: false
    attribute :preloaded, kind: :boolean, required: false
    attribute :required, kind: :boolean, required: false, default: true
    child kind: :module, min: 0, max: 1
  end
end
