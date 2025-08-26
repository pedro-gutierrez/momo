defmodule Sleeky.Model.Dsl.HasMany do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :name, kind: :module, required: false
    attribute :preloaded, kind: :boolean, required: false
    child kind: :module, min: 0, max: 1
  end
end
