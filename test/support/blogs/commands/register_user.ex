defmodule Blogs.Commands.RegisterUser do
  @moduledoc false

  use Momo.Command

  alias Blogs.Models.User
  alias Blogs.Events.UserRegistered
  alias Blogs.Expressions.IsGmailAccount
  alias Blogs.Expressions.LooksFake

  command params: User, atomic: true do
    policy role: :guest

    publish event: UserRegistered, if: IsGmailAccount, unless: LooksFake
  end

  def handle(%{email: "foo@bar.com"}, _context), do: {:error, :invalid_email}
  def handle(user, _context), do: User.create(user)
end
