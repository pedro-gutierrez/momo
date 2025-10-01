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
end
