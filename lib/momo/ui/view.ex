defmodule Momo.Ui.View do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    overrides: [div: 2],
    generators: [
      Momo.Ui.View.Generator.Source,
      Momo.Ui.View.Generator.Render,
      Momo.Ui.View.Generator.Data
    ]
end
