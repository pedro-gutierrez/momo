defmodule Momo.Ui.Form do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Ui.Form.Dsl,
    overrides: [form: 1],
    parser: Momo.Ui.Form.Parser,
    generators: [
      Momo.Ui.Form.Generator.Metadata,
      Momo.Ui.Form.Generator.View,
      Momo.Ui.Form.Generator.Route,
      Momo.Ui.Form.Generator.Action,
      Momo.Ui.Form.Generator.Delegates
    ]

  defstruct [:model, :command, :binding, :route, :action_path, :redirect]

  alias Momo.Maps

  @doc """
  Execute a form action

  This function takes the params from the request and invokes the feature command configured for the form
  """
  def action(form, params) do
    feature = form.command().feature()
    fun_name = form.command().fun_name()

    case apply(feature, fun_name, [params]) do
      {:ok, result} ->
        redirect = redirect(form, params, result)
        IO.inspect(result: result, redirect: redirect)

        {:redirect, redirect}

      {:error, error} ->
        {:error, error}
    end
  end

  defp redirect(form, params, result) do
    path = form.redirect()

    result = Maps.string_keys(result)
    params = Map.merge(params, result)

    :bbmustache.render(path, params, key_type: :binary)
  end
end
