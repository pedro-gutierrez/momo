defmodule Momo.Ui.Form.Generator.View do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(form, _options) do
    command = form.command
    fields = form_fields(form)

    action =
      form.action
      |> String.split("/")
      |> Enum.map_join("/", fn
        ":" <> param -> "{{ #{param} }}"
        param -> param
      end)

    definition =
      {:view, [],
       [
         {:div, [],
          [
            {:h1, [], [command.title()]},
            {:form, [action: action, method: "post", "up-submit": true, "up-target": "form"],
             [
               {:fieldset, [], fields},
               {:input, [type: "submit", value: "Submit"], []}
             ]}
          ]}
       ]}

    quote do
      defmodule View do
        use Momo.Ui.View

        @definition unquote(Macro.escape(definition))
      end
    end
  end

  defp form_fields(form) do
    model = form.model

    model.field_names()
    |> Enum.reject(&(&1 in [:id, :inserted_at, :updated_at]))
    |> Enum.map(&model.field!(&1))
    |> Enum.reject(& &1.computation)
    |> Enum.map(fn field ->
      label = label(field.name)
      form_field = field |> form_fields(form) |> List.flatten()
      {:label, [], [label, form_field]}
    end)
  end

  defp label(field) do
    field |> to_string() |> String.split("_") |> Enum.map_join(" ", &String.capitalize/1)
  end

  defp type(:date), do: "date"
  defp type(_), do: "text"

  defp form_fields(field, form) do
    cond do
      field.in ->
        options =
          for {label, value} <- field.in.options() do
            {:option,
             [
               value: value,
               selected: {true, "#{form.binding}.#{field.name} = #{inspect(value)}"}
             ], [label]}
          end

        [{:select, [name: field.name], options}]

      true ->
        type = type(field.kind)

        [
          {:input,
           [
             "aria-invalid": {"true", "{{ errors.#{field.name} }}"},
             type: type,
             name: field.name,
             placeholder: "Enter #{field.name}",
             value: "{{ #{form.binding}.#{field.name} }}"
           ], []},
          {:small, [if: "{{ errors.#{field.name} }}"], ["{{ errors.#{field.name} }}"]}
        ]
    end
  end
end
