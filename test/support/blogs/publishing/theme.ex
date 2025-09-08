defmodule Blogs.Publishing.Theme do
  @moduledoc false
  use Momo.Model

  alias Blogs.Publishing.Enums.Theme

  model do
    attribute :name, kind: :string, in: Theme

    unique fields: [:name] do
      on_conflict strategy: :merge
    end
  end
end
