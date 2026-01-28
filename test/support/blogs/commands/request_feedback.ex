defmodule Blogs.Commands.RequestFeedback do
  @moduledoc false
  use Momo.Command
  alias Blogs.Values.UserId

  command params: UserId do
  end

  def handle(_user, _context), do: :ok
end
