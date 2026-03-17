defmodule Momo.App.Dsl.Events do
  @moduledoc false
  use Diesel.Tag

  tag do
    child kind: :module, min: 0
  end
end
