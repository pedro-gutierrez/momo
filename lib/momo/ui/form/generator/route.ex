defmodule Momo.Ui.Form.Generator.Route do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(form, opts) do
    caller = Keyword.fetch!(opts, :caller_module)
    view = Module.concat(caller, View)

    definition =
      {:route, [name: form.action, method: "post"],
       [
         {:view, [name: view, for: "default"], []}
       ]}

    route_module = Module.concat(caller, Route)

    IO.inspect(route_module: route_module)

    quote do
      defmodule unquote(route_module) do
        use Momo.Ui.Route

        @definition unquote(Macro.escape(definition))

        def execute(params), do: Momo.Ui.Form.execute_route(unquote(caller), params)
      end
    end
  end
end
