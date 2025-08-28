defmodule Momo.Feature do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Feature.Dsl,
    parsers: [
      Momo.Feature.Parser
    ],
    generators: [
      Momo.Feature.Generator.Metadata,
      Momo.Feature.Generator.Roles,
      Momo.Feature.Generator.Graph,
      Momo.Feature.Generator.Map,
      Momo.Feature.Generator.CreateFunctions,
      Momo.Feature.Generator.UpdateFunctions,
      Momo.Feature.Generator.Commands,
      Momo.Feature.Generator.Queries,
      Momo.Feature.Generator.Flows
    ]

  defstruct [
    :app,
    :name,
    :repo,
    scopes: [],
    models: [],
    handlers: [],
    commands: [],
    queries: [],
    events: [],
    flows: [],
    subscriptions: [],
    values: []
  ]

  require Logger

  import Momo.Maps

  @doc """
  Map the input value, using a configured mapping or a generic one
  """
  def map(feature, from, to, input) do
    mapping = feature.mappings() |> Enum.find(&(&1.from() == from && &1.to() == to))

    case mapping do
      nil -> map(input, to)
      mapping -> mapping.map(input)
    end
  end

  defp map(input, to) when is_map(input) do
    input |> plain_map() |> to.new()
  end

  defp map(input, to) when is_list(input) do
    with items when is_list(items) <-
           Enum.reduce_while(input, [], fn item, acc ->
             case map(item, to) do
               {:ok, item} -> {:cont, [item | acc]}
               {:error, _} = error -> {:halt, error}
             end
           end),
         do: {:ok, Enum.reverse(items)}
  end

  @doc """
  Executes a command and publishes events

  This function does not take a context, which will disable permission checks
  """
  def execute_command(command, params) do
    if command.atomic?() do
      repo = command.feature().repo()

      repo.transaction(fn ->
        with {:error, reason} <- do_execute_command(command, params) do
          repo.rollback(reason)
        end
      end)
    else
      do_execute_command(command, params)
    end
  end

  @doc """
  Executes a command, publishes events, and returns a result

  This function takes a context, which will trigger checking for permissions based on policies, roles and scopes
  """
  def execute_command(command, params, context) do
    if command.atomic?() do
      repo = command.feature().repo()

      repo.transaction(fn ->
        with {:error, reason} <- do_execute_command(command, params, context) do
          repo.rollback(reason)
        end
      end)
    else
      do_execute_command(command, params, context)
    end
  end

  defp do_execute_command(command, params) do
    with {:ok, params} <- params |> plain_map() |> command.params().validate(),
         {:ok, result, events} <- command.execute(params),
         :ok <- publish_events(events, command.feature()) do
      {:ok, result}
    end
  end

  defp do_execute_command(command, params, context) do
    with {:ok, params} <- params |> plain_map() |> command.params().validate(),
         context <- Map.put(context, :params, params),
         :ok <- allow(command, context),
         {:ok, result, events} <- command.execute(params, context),
         :ok <- publish_events(events, command.feature()) do
      {:ok, result}
    end
  end

  defp allow(command, context) do
    if command.allowed?(context) do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Publish the given list of events

  Events are only published if there are subscriptions for them.
  """
  def publish_events([], _feature), do: :ok

  def publish_events(events, feature) do
    app = feature.app()

    events
    |> Enum.flat_map(&jobs(&1, app))
    |> Momo.Job.schedule_all()

    :ok
  end

  defp jobs(event, app) do
    jobs =
      app.features()
      |> Enum.flat_map(& &1.subscriptions())
      |> Enum.filter(&(&1.event() == event.__struct__))
      |> Enum.map(&[event: event.__struct__, params: Jason.encode!(event), subscription: &1])

    if jobs == [] do
      Logger.warning("No subscriptions found for event", event: event.__struct__)
    end

    jobs
  end

  @doc """
  Executes a query that has parameters
  """
  def execute_query(query, params, context), do: query.execute(params, context)

  @doc """
  Executes a query that has no parameters
  """
  def execute_query(query, params), do: query.execute(params)
end
