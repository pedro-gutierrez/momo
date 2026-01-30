defmodule Blogs.Queries.GetUsersByEmails do
  @moduledoc false
  use Momo.Query

  alias Blogs.Models.User
  alias Blogs.Values.UserEmails

  query params: UserEmails, returns: User, many: true do
    policy role: :user
  end
end
