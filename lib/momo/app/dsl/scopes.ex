defmodule Momo.App.Dsl.Scopes do
  @moduledoc false
  use Diesel.Tag

  tag do
    child kind: :module, min: 0
  end
end
