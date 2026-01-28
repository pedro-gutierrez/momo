defmodule Blogs.Scopes.SelfAndNotLocked do
  @moduledoc false
  use Momo.Scope

  scope do
    all do
      Blogs.Scopes.Self
      Blogs.Scopes.NotLocked
    end
  end
end
