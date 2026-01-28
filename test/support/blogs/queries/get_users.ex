defmodule Blogs.Queries.GetUsers do
  @moduledoc false
  use Momo.Query

  alias Blogs.User
  alias Blogs.Scopes.IsPublic

  query returns: User, many: true do
    policy role: :guest, scope: IsPublic
  end
end
