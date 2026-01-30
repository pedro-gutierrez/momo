defmodule Blogs.Models.Author do
  @moduledoc false
  use Momo.Model

  model do
    attribute :name, kind: :string
    attribute :profile, kind: :string, default: "publisher"
    has_many Blogs.Models.Blog
  end
end
