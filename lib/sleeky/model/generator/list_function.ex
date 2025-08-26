defmodule Sleeky.Model.Generator.ListFunction do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(model, _) do
    preloads = model.relations |> Enum.filter(& &1.preloaded?) |> Enum.map(& &1.name)

    quote do
      def list(opts \\ []) do
        query = Keyword.get(opts, :query, __MODULE__)
        preload = Keyword.get(opts, :preload, unquote(preloads))
        query = from(q in query, preload: ^preload)

        opts
        |> Keyword.get(:sort, inserted_at: :asc)
        |> Enum.reduce(query, fn
          {field, :asc}, q -> q |> order_by([q], asc: field(q, ^field))
          {field, :desc}, q -> q |> order_by([q], desc: field(q, ^field))
        end)
        |> @repo.all()
      end
    end
  end
end
