defmodule Momo.Query do
  @moduledoc false
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Query.Dsl,
    parser: Momo.Query.Parser,
    generators: [
      Momo.Query.Generator.Execute,
      Momo.Query.Generator.Handle,
      Momo.Query.Generator.Metadata,
      Momo.Query.Generator.Scope
    ]

  alias Momo.QueryBuilder

  defstruct [
    :name,
    :feature,
    :params,
    :sorting,
    :model,
    :policies,
    :limit,
    :many,
    :custom,
    :debug
  ]

  defmodule Policy do
    @moduledoc false
    defstruct [:role, :scope]
  end

  defmodule Sort do
    @moduledoc false
    defstruct [:field, :direction]
  end

  import Ecto.Query
  import Momo.Maps

  require Logger

  @doc """
  Returns the feature function name for a query
  """
  def fun_name(query) do
    query
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
    |> String.to_atom()
  end

  @doc """
  Builds a query based on the model of the given query

  The query is enhanced with filters derived from the policies and scopes of the query. If however the query does not define any policy, then scoping is skipped.
  """
  def scope(query, context) do
    model = query.model()

    with false <- Enum.empty?(query.policies()),
         {:ok, [_ | _] = roles} <- query.feature().app().roles_from_context(context) do
      scope(model, roles, query.policies(), context)
    else
      true -> model
      {:ok, []} -> model
      {:error, :no_such_roles_path} -> nothing(model)
    end
  end

  defp scope(model, roles, policies, context) do
    policies =
      roles
      |> Enum.map(&Map.get(policies, &1))
      |> Enum.reject(&is_nil/1)

    if policies == [] do
      nothing(model)
    else
      Enum.reduce(policies, model, &scope_with(&1, &2, context))
    end
  end

  defp scope_with(policy, model, context) do
    if policy.scope do
      policy.scope.scope(model, context)
    else
      model
    end
  end

  defp nothing(model), do: where(model, false)

  @doc """
  Executes the query with the given parameters and context
  """
  def execute(query, params, context) do
    params = params(params)

    with {:ok, params} <- query.params().validate(params),
         context <- Map.put(context, :params, params) do
      if query.custom?() do
        params
        |> query.handle(context)
        |> maybe_map_result(query)
        |> wrap_result()
      else
        context
        |> query.scope()
        |> apply_filters(query, params)
        |> apply_preloads(query)
        |> apply_sorting(query)
        |> query.handle(params, context)
        |> call_repo(query, context)
      end
    end
  end

  @doc """
  Executes the query that has no params
  """
  def execute(query, context) do
    if query.custom?() do
      context
      |> query.handle()
      |> maybe_map_result(query)
      |> wrap_result()
    else
      context
      |> query.scope()
      |> apply_preloads(query)
      |> apply_sorting(query)
      |> query.handle(context)
      |> call_repo(query, context)
    end
  end

  defp params(params) when is_struct(params), do: Map.from_struct(params)
  defp params(params) when is_list(params), do: Map.new(params)
  defp params(params) when is_map(params), do: params

  defp call_repo(queriable, query, _context) do
    repo = query.feature().repo()
    Logger.debug("Executing query", query: query, computed: inspect(queriable))

    if query.many?() do
      queriable |> repo.all()
    else
      case repo.one(queriable) do
        nil -> {:error, :not_found}
        item -> {:ok, item}
      end
    end
  end

  defp maybe_map_result(item, query) do
    case query.model() do
      nil -> item
      model -> maybe_map_result(item, query, model)
    end
  end

  defp maybe_map_result(nil, _query, _model), do: nil

  defp maybe_map_result(items, query, model) when is_list(items),
    do: Enum.map(items, &maybe_map_result(&1, query, model))

  defp maybe_map_result(item, query, model) do
    if same_model?(item, model) do
      item
    else
      with {:ok, mapped} <- query.feature().map(Map, model, item) do
        mapped
      end
    end
  end

  defp same_model?(item, model), do: is_struct(item) && item.__struct__ == model

  defp wrap_result(nil), do: {:error, :not_found}
  defp wrap_result(item) when is_struct(item), do: {:ok, item}
  defp wrap_result(items) when is_list(items), do: items
  defp wrap_result({:ok, items}) when is_list(items), do: items
  defp wrap_result({:ok, item}) when is_struct(item), do: {:ok, item}

  @doc """
  Builds a query by taking the parameters and adding them as filters
  """
  def apply_filters(q, _query, params) do
    filters =
      for {field, value} <- plain_map(params) do
        {field, :eq, value}
      end

    Momo.QueryBuilder.filter(q, filters)
  end

  @doc """
  Applies sorting to the query
  """
  def apply_sorting(q, query) do
    sorting =
      for %{field: field, direction: direction} <- query.sorting() do
        {field, direction}
      end

    QueryBuilder.sort(q, sorting)
  end

  @doc """
  Applies preloads to the query
  """
  def apply_preloads(q, query) do
    preload =
      query.model().relations()
      |> Enum.filter(& &1.preloaded?)
      |> Enum.map(& &1.name)

    from(item in q, preload: ^preload)
  end
end
