defmodule Blogs.Models.Post do
  @moduledoc false
  use Momo.Model

  model do
    attribute :title, kind: :string
    attribute :published_at, kind: :datetime, required: false
    attribute :locked, kind: :boolean, required: true, default: false
    attribute :published, kind: :boolean, required: true, default: false
    attribute :deleted, kind: :boolean, required: true, default: false
    belongs_to Blogs.Models.Blog
    belongs_to Blogs.Models.Author
    has_many Blogs.Models.Comment
  end
end
