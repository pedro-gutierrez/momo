defmodule Blogs.Comment do
  @moduledoc false
  use Momo.Model

  alias Blogs.{Author, Post}

  model do
    attribute :body, kind: :string
    belongs_to Post
    belongs_to Author
  end
end
