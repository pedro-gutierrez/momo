defmodule Momo.Ui.Namespace.Generator.Metadata do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(ns, _opts) do
    routes =
      for route <- ns.routes do
        {route.method(), route.path()}
      end

    quote do
      def path, do: unquote(ns.path)
      def routes, do: unquote(routes)
    end
  end
end
