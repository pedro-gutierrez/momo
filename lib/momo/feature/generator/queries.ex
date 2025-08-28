defmodule Momo.Feature.Generator.Queries do
  @moduledoc false

  @behaviour Diesel.Generator

  @impl true
  def generate(feature, _opts) do
    for query <- feature.queries do
      fun_name = Momo.Query.fun_name(query)
      params_module = query.params()

      if params_module != nil do
        quote do
          def unquote(fun_name)(params, context \\ %{}),
            do: Momo.Feature.execute_query(unquote(query), params, context)
        end
      else
        quote do
          def unquote(fun_name)(context \\ %{}),
            do: Momo.Feature.execute_query(unquote(query), context)
        end
      end
    end
  end
end
