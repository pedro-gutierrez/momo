defmodule Blogs.Commands.RequestFeedback do
  @moduledoc false
  use Momo.Command

  command params: Blogs.Values.UserId, handler: Blogs.Handlers.RequestFeedback
end
