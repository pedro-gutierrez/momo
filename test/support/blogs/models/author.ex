defmodule Blogs.Author do
  @moduledoc false
  use Momo.Model

  alias Blogs.Blog

  model do
    attribute :name, kind: :string
    attribute :profile, kind: :string, default: "publisher"
    has_many Blog
  end
end
