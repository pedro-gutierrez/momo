defmodule Momo.App.Dsl.Subscriptions do
  @moduledoc false
  use Diesel.Tag

  tag do
    child kind: :module, min: 0
  end
end
