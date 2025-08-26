defmodule Blogs.Publishing.Post do
  @moduledoc false
  use Sleeky.Model

  alias Blogs.Publishing.{Author, Blog, Comment}

  model do
    attribute :title, kind: :string
    attribute :published_at, kind: :datetime, required: false
    attribute :locked, kind: :boolean, required: true, default: false
    attribute :published, kind: :boolean, required: true, default: false
    attribute :deleted, kind: :boolean, required: true, default: false
    belongs_to Blog
    belongs_to Author
    has_many Comment
  end
end
