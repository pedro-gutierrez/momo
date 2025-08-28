defmodule Momo.Ui.View.Generator.Render do
  @moduledoc false
  @behaviour Diesel.Generator

  # alias Momo.Ui.View

  @impl true
  def generate(html, _opts) do
    quote do
      @expanded_source unquote(Macro.escape(html))

      def render(args \\ %{}) do
        @expanded_source
        |> Momo.Ui.View.Resolve.resolve(args)
        |> Momo.Ui.View.Render.render()
        |> to_string()
      end
    end
  end
end
