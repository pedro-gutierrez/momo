defmodule Momo.Command.Dsl.Command do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :params, kind: :module, required: true
    attribute :returns, kind: :module, required: false
    attribute :many, kind: :boolean, required: false, default: false
    attribute :atomic, kind: :boolean, required: false, default: false
    attribute :title, kind: :string, required: false

    child :policy, min: 0
    child :publish, min: 0
  end
end
