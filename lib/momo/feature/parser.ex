defmodule Momo.Feature.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Feature
  import Momo.Naming

  @impl true
  def parse({:feature, _, children}, opts) do
    caller_module = Keyword.fetch!(opts, :caller_module)
    name = name(caller_module)
    repo = repo(caller_module)
    app = app(caller_module)

    %Feature{name: name, repo: repo, app: app}
    |> with_modules(children, :scopes)
    |> with_modules(children, :models)
    |> with_modules(children, :commands)
    |> with_modules(children, :handlers)
    |> with_modules(children, :queries)
    |> with_modules(children, :events)
    |> with_modules(children, :flows)
    |> with_modules(children, :subscriptions)
    |> with_modules(children, :mappings)
    |> with_modules(children, :values)
    |> ensure_command_event_compatibility!()
  end

  defp with_modules(feature, children, kind) do
    mods = for {^kind, _, mods} <- children, do: mods
    mods = List.flatten(mods)

    Map.put(feature, kind, mods)
  end

  defp ensure_command_event_compatibility!(feature) do
    for command <- feature.commands, event <- command.events() do
      event_module = event.module
      input = Enum.find(feature.mappings, &(&1 == event.mapping)) || command.returns()
      input_fields = with fields when is_map(fields) <- input.fields(), do: Map.values(fields)

      for field when field.required <- event_module.fields() do
        if input_fields |> Enum.find(&(&1.name == field.name)) |> is_nil() do
          raise """
          Event #{inspect(event_module)} cannot be mapped from the output of command #{inspect(command)} because field #{inspect(field.name)} does not exist in #{inspect(input)}.
          """
        end
      end
    end

    feature
  end
end
