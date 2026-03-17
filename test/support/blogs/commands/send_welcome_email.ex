defmodule Blogs.Commands.SendWelcomeEmail do
  @moduledoc false
  use Momo.Command

  command params: Blogs.Values.UserId, handler: Blogs.Handlers.SendWelcomeEmail
end
