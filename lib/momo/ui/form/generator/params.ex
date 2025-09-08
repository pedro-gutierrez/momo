defmodule Momo.Ui.Form.Generator.Params do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_form, _opts) do
    quote do
      def params(params), do: params

      defoverridable params: 1
    end
  end
end
