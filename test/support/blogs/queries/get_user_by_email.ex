defmodule Blogs.Queries.GetUserByEmail do
  @moduledoc false
  use Momo.Query

  alias Blogs.User
  alias Blogs.Values.UserEmail

  query params: UserEmail, returns: User do
    policy role: :user
  end
end
