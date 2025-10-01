defmodule Momo.Ui.Generator.Routes do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(ui, _opts) do
    namespaces = Momo.Ui.namespaces(ui)

    routes =
      for ns <- namespaces, {method, path} <- ns.routes() do
        path = ns.path() <> path
        path = String.replace(path, "//", "/")

        {method, path}
      end

    quote do
      def routes, do: unquote(routes)
    end
  end
end
