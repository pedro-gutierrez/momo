defmodule Blogs.Commands.EnableUser do
  @moduledoc false
  use Momo.Command

  command params: Blogs.Values.UserId, handler: Blogs.Handlers.EnableUser
end
