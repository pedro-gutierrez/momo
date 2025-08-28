defmodule Momo.Model.Generator.Helpers do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_model, _) do
    quote do
      import Momo.Model.Helpers
    end
  end
end
