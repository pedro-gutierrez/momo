defmodule Blogs.Accounts.Mappings.UserRegisteredFromUser do
  @moduledoc false
  use Momo.Mapping

  alias Blogs.Accounts.User
  alias Blogs.Accounts.Events.UserRegistered

  mapping from: User, to: UserRegistered do
    field :user_id, path: "id"
    field :registered_at, path: "inserted_at"
  end
end
