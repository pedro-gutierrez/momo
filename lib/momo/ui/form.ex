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
      Momo.Ui.Form.Generator.Delegates,
      Momo.Ui.Form.Generator.Params
    ]

  defstruct [:id, :model, :command, :binding, :action, :action_path, :redirect]

  alias Momo.Maps
  alias Momo.Error

  @doc """
  Execute a form route

  This function takes the params from the request and invokes the feature command configured for the form
  """
  def execute_route(form, params) do
    params = form.params(params)
    feature = form.command().feature()
    fun_name = form.command().fun_name()

    case apply(feature, fun_name, [params]) do
      {:ok, result} ->
        {:redirect, redirect(form, params, result)}

      {:error, %Ecto.Changeset{} = errors} ->
        {params, model} = Map.split(params, ["glob"])
        errors = Error.simple(errors)

        params
        |> Map.put(form.binding(), model)
        |> Map.put("errors", errors)

      other ->
        other
    end
  end

  defp redirect(form, params, result) do
    path = form.redirect()

    result = Maps.string_keys(result)
    params = Map.merge(params, result)

    :bbmustache.render(path, params, key_type: :binary)
  end
end
