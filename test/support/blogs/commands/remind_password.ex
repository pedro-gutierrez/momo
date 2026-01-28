defmodule Blogs.Commands.RemindPassword do
  @moduledoc false

  use Momo.Command

  alias Blogs.Scopes.SelfAndNotLocked
  alias Blogs.Values.UserId

  command params: UserId do
    policy role: :user, scope: SelfAndNotLocked
  end

  def handle(_params, _context), do: :ok
end
