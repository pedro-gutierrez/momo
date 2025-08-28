defmodule Blogs.Accounts.Scopes.SelfAndNotLocked do
  @moduledoc false
  use Momo.Scope

  scope do
    all do
      Blogs.Accounts.Scopes.Self
      Blogs.Accounts.Scopes.NotLocked
    end
  end
end
