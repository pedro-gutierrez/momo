defmodule Momo.Ui.Form.Dsl.Form do
  @moduledoc false
  use Diesel.Tag

  tag do
    attribute :model, kind: :module, required: true
    attribute :command, kind: :module, required: true
    attribute :binding, kind: :string, required: false
    attribute :route, kind: :string, required: true
    attribute :redirect, kind: :string, required: true
  end
end
