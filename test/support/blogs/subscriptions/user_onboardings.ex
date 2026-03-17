defmodule Blogs.Subscriptions.UserOnboardings do
  @moduledoc false
  use Momo.Subscription

  subscription(
    on: Blogs.Events.UserOnboarded,
    perform: Blogs.Commands.RequestFeedback
  )
end
