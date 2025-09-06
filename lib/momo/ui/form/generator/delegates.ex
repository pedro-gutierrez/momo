defmodule Momo.Ui.Form.Generator.Delegates do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_form, _options) do
    quote do
      defdelegate render(args), to: __MODULE__.View
      defdelegate source, to: __MODULE__.View
    end
  end
end
