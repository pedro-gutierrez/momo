defmodule Blogs.Models.Comment do
  @moduledoc false
  use Momo.Model

  model do
    attribute :body, kind: :string
    belongs_to Blogs.Models.Post
    belongs_to Blogs.Models.Author
  end
end
