defmodule Blogs.Publishing.Theme do
  @moduledoc false
  use Sleeky.Model

  model do
    attribute :name, kind: :string, in: ["science", "finance"]

    unique fields: [:name] do
      on_conflict strategy: :merge
    end
  end
end
