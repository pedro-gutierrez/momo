defmodule Blogs.Accounts.Scopes.NotLocked do
  @moduledoc false
  use Momo.Scope

  scope do
    is_false do
      path "user.locked"
    end
  end
end
