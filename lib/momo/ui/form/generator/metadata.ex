defmodule Momo.Ui.Form.Generator.Metadata do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(form, _opts) do
    quote do
      def command, do: unquote(form.command)
      def redirect, do: unquote(form.redirect)
    end
  end
end
