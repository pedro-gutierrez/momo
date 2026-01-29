defmodule Momo.Ui.Generator.Routes do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(ui, _opts) do
    routes = for {method, path, _} <- Momo.Ui.routes(ui) do
      {method, path}
    end

    quote do
      def routes, do: unquote(routes)
    end
  end
end
