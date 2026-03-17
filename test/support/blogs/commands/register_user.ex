defmodule Blogs.Commands.RegisterUser do
  @moduledoc false

  use Momo.Command

  alias Blogs.Models.User
  alias Blogs.Events.UserRegistered
  alias Blogs.Expressions.IsGmailAccount
  alias Blogs.Expressions.LooksFake

  command params: User, atomic: true, handler: Blogs.Handlers.RegisterUser do
    policy role: :guest

    publish event: UserRegistered, if: IsGmailAccount, unless: LooksFake
  end
end
