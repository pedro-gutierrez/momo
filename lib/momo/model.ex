defmodule Momo.Model do
  use Diesel,
    otp_app: :momo,
    dsl: Momo.Model.Dsl,
    parsers: [
      Momo.Model.Parser
    ],
    generators: [
      Momo.Model.Generator.Metadata,
      Momo.Model.Generator.Cast,
      Momo.Model.Generator.EctoSchema,
      Momo.Model.Generator.Validate,
      Momo.Model.Generator.Helpers,
      Momo.Model.Generator.FieldNames,
      Momo.Model.Generator.Changesets,
      Momo.Model.Generator.CreateFunction,
      Momo.Model.Generator.FetchFunction,
      Momo.Model.Generator.EditFunction,
      Momo.Model.Generator.DeleteFunction,
      Momo.Model.Generator.ListFunction,
      Momo.Model.Generator.Query
    ]

  defstruct [
    :module,
    :feature,
    :repo,
    :name,
    :plural,
    :primary_key,
    :table_name,
    virtual?: false,
    attributes: [],
    relations: [],
    keys: [],
    actions: []
  ]

  defmodule Key do
    @moduledoc false

    defstruct [
      :fields,
      :model,
      :name,
      on_conflict: nil,
      unique?: false
    ]
  end

  defmodule Attribute do
    @moduledoc false

    defstruct [
      :name,
      :kind,
      :ecto_type,
      :storage,
      :default,
      :enum,
      :column_name,
      required?: true,
      primary_key?: false,
      virtual?: false,
      computed?: false,
      mutable?: true,
      timestamp?: false,
      in: [],
      aliases: []
    ]
  end

  defmodule Relation do
    @moduledoc false

    defstruct [
      :name,
      :model,
      :kind,
      :target,
      :table_name,
      :column_name,
      :foreign_key_name,
      :storage,
      :inverse,
      :default,
      required?: true,
      virtual?: false,
      computed?: false,
      mutable?: true,
      preloaded?: false,
      aliases: []
    ]
  end

  defmodule Action do
    @moduledoc false

    defstruct [
      :name,
      :kind,
      policies: %{},
      tasks: []
    ]
  end

  defmodule OnConflict do
    @moduledoc false

    defstruct [
      :fields,
      :strategy,
      :except
    ]
  end

  defmodule Task do
    @moduledoc false

    defstruct [
      :module,
      :if
    ]
  end

  defmodule Policy do
    @moduledoc false

    defstruct [
      :role,
      :scope,
      :policy
    ]
  end
end
