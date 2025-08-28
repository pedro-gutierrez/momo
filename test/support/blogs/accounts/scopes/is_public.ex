defmodule Blogs.Accounts.Scopes.IsPublic do
  @moduledoc false
  use Momo.Scope

  scope do
    is_true do
      path "public"
    end
  end
end
