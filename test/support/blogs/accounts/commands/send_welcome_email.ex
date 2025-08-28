defmodule Blogs.Accounts.Commands.SendWelcomeEmail do
  @moduledoc false
  use Momo.Command

  alias Blogs.Accounts.Values.UserId

  command params: UserId do
  end

  def handle(_user, _context), do: :ok
end
