defmodule Momo.Ui.Namespace.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Ui.Namespace.Dsl.Namespace,
    tags: [
      Momo.Ui.Namespace.Dsl.Routes
    ]
end
