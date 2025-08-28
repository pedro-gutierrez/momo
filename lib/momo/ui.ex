defmodule Momo.Ui do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Ui.Dsl,
    generators: [
      Momo.Ui.Generator.Router
    ]

  defstruct [:pages, :namespaces, :error_view, :not_found_view]

  defmodule Page do
    @moduledoc false
    defstruct [:method, :path, :module, :runtime]
  end
end
