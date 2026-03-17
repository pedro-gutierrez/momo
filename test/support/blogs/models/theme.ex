defmodule Blogs.Models.Theme do
  @moduledoc false
  use Momo.Model

  model do
    attribute :name, kind: :string, in: Blogs.Enums.Theme

    unique fields: [:name] do
      on_conflict strategy: :merge
    end
  end
end
