defmodule Momo.Model.Generator.CreateFunction do
  @moduledoc false
  @behaviour Diesel.Generator

  alias Momo.Model
  alias Momo.Model.OnConflict

  @impl true
  def generate(model, _) do
    [
      with_defaults(),
      with_struct_args(model),
      with_keyword_args(model),
      with_map_args(model),
      batch_fun(model)
    ]
  end

  defp with_defaults() do
    quote do
      def create(attrs, opts \\ [])
    end
  end

  defp with_map_args(model) do
    conflict_opts = on_conflict_opts(model) || []

    quote location: :keep do
      def create(attrs, opts) when is_map(attrs) do
        opts = Keyword.merge(unquote(conflict_opts), opts)

        %__MODULE__{}
        |> insert_changeset(attrs, opts)
        |> __MODULE__.app().repo().insert(opts)
      end
    end
  end

  defp with_keyword_args(_model) do
    quote location: :keep do
      def create(attrs, opts) when is_list(attrs) do
        attrs
        |> Map.new()
        |> create(opts)
      end
    end
  end

  defp with_struct_args(_model) do
    quote location: :keep do
      def create(attrs, opts) when is_struct(attrs) do
        attrs
        |> Map.from_struct()
        |> create(opts)
      end
    end
  end

  defp batch_fun(model) do
    conflict_opts = on_conflict_opts(model) || []

    quote location: :keep do
      def create_many(items, opts \\ []) when is_list(items) do
        opts = Keyword.merge(unquote(conflict_opts), opts)
        now = DateTime.utc_now()
        unique_by = opts[:unique_by] || :id

        items =
          items
          |> Enum.map(fn item ->
            item
            |> batch_insert_changeset(opts)
            |> apply_changes()
            |> Map.from_struct()
            |> Map.drop(@relation_field_names ++ [:__meta__])
          end)
          |> Enum.uniq_by(&Map.fetch!(&1, unique_by))

        @repo.insert_all(__MODULE__, items, opts)

        :ok
      end
    end
  end

  defp on_conflict_opts(%OnConflict{strategy: :merge, fields: fields, except: except})
       when length(except) > 0 do
    [on_conflict: {:replace_all_except, except}, conflict_target: fields, returning: true]
  end

  defp on_conflict_opts(%Model{} = model) do
    model.keys
    |> Enum.filter(& &1.on_conflict)
    |> Enum.map(&on_conflict_opts(&1.on_conflict))
    |> List.first()
  end
end
