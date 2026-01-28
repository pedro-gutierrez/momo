defmodule Blogs.Blog do
  @moduledoc false
  use Momo.Model

  alias Blogs.{Author, Post, Theme}

  model do
    attribute :name, kind: :string
    attribute :published, kind: :boolean, required: true, default: false
    attribute :public, kind: :boolean, required: false, default: false
    belongs_to Author
    belongs_to Theme, required: false
    has_many Post
    unique fields: [:author, :name]
  end
end
