defmodule Blogs.Models.Blog do
  @moduledoc false
  use Momo.Model

  model do
    attribute :name, kind: :string
    attribute :published, kind: :boolean, required: true, default: false
    attribute :public, kind: :boolean, required: false, default: false
    belongs_to Blogs.Models.Author
    belongs_to Blogs.Models.Theme, required: false
    has_many Blogs.Models.Post
    unique fields: [:author, :name]
  end
end
