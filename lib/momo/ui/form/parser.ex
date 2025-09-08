defmodule Momo.Ui.Form.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Ui.Form

  @impl true
  def parse({:form, attrs, _children}, opts) do
    model = Keyword.fetch!(attrs, :model)
    command = Keyword.fetch!(attrs, :command)

    default_binding = attrs |> Keyword.get(:binding) |> binding(model)

    binding = attrs[:binding] || default_binding

    redirect =
      attrs
      |> Keyword.fetch!(:redirect)
      |> String.split("/")
      |> Enum.map_join("/", fn
        ":" <> param -> "{{ #{param} }}"
        segment -> segment
      end)

    action = Keyword.fetch!(attrs, :action)

    form_id =
      opts
      |> Keyword.fetch!(:caller_module)
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    %Form{
      id: form_id,
      model: model,
      command: command,
      binding: binding,
      action: action,
      redirect: redirect
    }
  end

  defp binding(nil, model), do: model.name() |> to_string()
  defp binding(binding, _), do: binding
end
