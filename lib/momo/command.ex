defmodule Momo.Command do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Command.Dsl,
    generators: [
      Momo.Command.Generator.Metadata,
      Momo.Command.Generator.Allow,
      Momo.Command.Generator.Execute
    ]

  defstruct [
    :name,
    :title,
    :fun_name,
    :app,
    :params,
    :returns,
    :many,
    :policies,
    :atomic?,
    :handler,
    :events,
    :path
  ]

  require Logger
  import Momo.Maps

  defmodule Policy do
    @moduledoc false
    defstruct [:role, :scope]
  end

  defmodule Event do
    @moduledoc false
    defstruct [:module, :source, :mapping, :if, :unless]
  end

  def allowed?(command, context) do
    case command.app().roles_from_context(context) do
      {:ok, []} ->
        true

      {:ok, roles} ->
        allowed(roles, command.policies(), context)

      _ ->
        false
    end
  end

  defp allowed(roles, policies, context) do
    policies =
      roles
      |> Enum.map(&Map.get(policies, &1))
      |> Enum.reject(&is_nil/1)

    if policies == [] do
      false
    else
      Enum.reduce_while(policies, false, fn policy, _ ->
        if !policy.scope || policy.scope.allowed?(context) do
          {:halt, true}
        else
          {:cont, false}
        end
      end)
    end
  end

  @doc """
  Executes a command and publishes any events emitted
  """
  def execute(command, params, context) do
    if command.atomic?() do
      repo = command.app().repo()

      repo.transaction(fn ->
        with {:error, reason} <- do_execute_command(command, params, context) do
          repo.rollback(reason)
        end
      end)
      |> then(fn
        {:ok, {:ok, result}} -> {:ok, result}
        {:ok, :ok} -> :ok
        {:error, _} = error -> error
      end)
    else
      do_execute_command(command, params, context)
    end
  end

  defp do_execute_command(command, params, context) do
    with {:ok, params} <- params |> plain_map() |> command.params().validate(),
         context <- Map.put(context, :params, params),
         :ok <- authorize(command, context),
         {:ok, result} <- handle(command, params, context),
         {:ok, events} <- events(command, result, context),
         :ok <- publish_events(command, events) do
        {:ok, result}
      end
  end

  defp authorize(_command, %{authorization: :skip}), do: :ok

  defp authorize(command, context) do
    if allowed?(command, context) do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  defp handle(command, params, context) do
    with :ok <- command.handle(params, context) do
      {:ok, params}
    end
  end

  defp events(command, result, context) do
    app = command.app()
    events = command.events()

    with events when is_list(events) <-
           Enum.reduce_while(events, [], fn event, acc ->
             case maybe_create_events(app, event, result, context) do
               nil -> {:cont, acc}
               {:ok, new_events} when is_list(new_events) -> {:cont, new_events ++ acc}
               {:ok, new_event} -> {:cont, [new_event | acc]}
               {:error, reason} -> {:halt, {:error, reason}}
             end
           end),
         do: {:ok, Enum.reverse(events)}
  end

  defp maybe_create_events(app, event, result, context) when is_list(result) do
    with events when is_list(events) <-
           Enum.reduce_while(result, [], fn item, acc ->
             case maybe_create_event(app, event, item, context) do
               nil -> {:cont, acc}
               {:ok, event} -> {:cont, [event | acc]}
               {:error, reason} -> {:halt, {:error, reason}}
             end
           end),
         do: {:ok, Enum.reverse(events)}
  end

  defp maybe_create_events(app, event, result, context) do
    maybe_create_events(app, event, [result], context)
  end

  defp maybe_create_event(app, event, result, context) do
    if_expr = event.if
    unless_expr = event.unless

    maybe_create_event(app, event, result, context, if_expr, unless_expr)
  end

  defp maybe_create_event(app, event, result, context, nil, nil),
    do: create_event(app, event, result, context)

  defp maybe_create_event(app, event, result, context, if_expr, nil) do
    if if_expr.execute(result, context), do: create_event(app, event, result, context)
  end

  defp maybe_create_event(app, event, result, context, nil, unless_expr) do
    if not unless_expr.execute(result, context), do: create_event(app, event, result, context)
  end

  defp maybe_create_event(app, event, result, context, if_expr, unless_expr) do
    if not unless_expr.execute(result, context) && if_expr.execute(result, context),
      do: create_event(app, event, result, context)
  end

  defp create_event(app, event, result, context) do
    data = result |> plain_map() |> Map.merge(context)

    app.map(event.source, event.module, data)
  end

  defp publish_events([], _feature), do: :ok

  defp publish_events(command, events) do
    app = command.app()

    events
    |> Enum.flat_map(&jobs(&1, app))
    |> Momo.Job.schedule_all()

    :ok
  end

  defp jobs(event, app) do
    jobs =
      app.subscriptions()
      |> Enum.filter(&(&1.event() == event.__struct__))
      |> Enum.map(&[event: event.__struct__, params: Jason.encode!(event), subscription: &1])

    if jobs == [] do
      Logger.warning("No subscriptions found for event", event: event.__struct__)
    end

    jobs
  end
end
