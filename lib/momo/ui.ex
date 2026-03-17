defmodule Momo.Ui do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Ui.Dsl,
    generators: [
      Momo.Ui.Generator.Routes,
      Momo.Ui.Generator.Router
    ]

  defstruct [:pages, :namespaces, :error_view, :not_found_view]

  defmodule Page do
    @moduledoc false
    defstruct [:method, :path, :module, :runtime]
  end

  @doc """
  Returns the list of namespaces for a ui.

  More specific namespaces are listed first.
  """
  def namespaces(ui), do: Enum.sort_by(ui.namespaces, &byte_size(&1.path()), :desc)

  @doc """
  Returns all routes configured for the given ui.

  Each route is a tuple {method, path, handler}
  """
  def routes(ui) do
    ui
    |> namespaces()
    |> Enum.flat_map(fn ns ->
      prefix = ns.path()

      for route <- ns.routes() do
        path = route.path()
        method = route.method()
        handler = Module.concat(route, Handler)
        path = String.replace(prefix <> path, "//", "/")

        {method, path, handler}
      end
    end)
  end
end
