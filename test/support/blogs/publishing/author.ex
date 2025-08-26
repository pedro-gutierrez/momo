defmodule Blogs.Publishing.Author do
  @moduledoc false
  use Sleeky.Model

  alias Blogs.Publishing.Blog

  model do
    attribute :name, kind: :string
    attribute :profile, kind: :string, default: "publisher"
    has_many Blog
  end
end
