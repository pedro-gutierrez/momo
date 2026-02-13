defmodule Blogs.Commands.RemindPassword do
  @moduledoc false
  use Momo.Command

  alias Blogs.Scopes.SelfAndNotLocked
  alias Blogs.Values.UserId

  command params: UserId, handler: Blogs.Handlers.RemindPassword do
    policy role: :user, scope: SelfAndNotLocked
  end
end
