defmodule Sleeky.Model.Dsl.Model do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :virtual, kind: :boolean, required: false, default: false
    child :attribute, min: 0
    child :belongs_to, min: 0
    child :has_many, min: 0
    child :key, min: 0
    child :unique, min: 0
  end
end
