defmodule Momo.Ui.Form.Generator.Action do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_form, opts) do
    form = Keyword.fetch!(opts, :caller_module)

    quote do
      defmodule Action do
        @moduledoc false
        def execute(params), do: Momo.Ui.Form.action(unquote(form), params)
      end
    end
  end
end
