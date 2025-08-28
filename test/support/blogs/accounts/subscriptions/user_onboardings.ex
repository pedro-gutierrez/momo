defmodule Blogs.Accounts.Subscriptions.UserOnboardings do
  @moduledoc false
  use Momo.Subscription

  subscription(
    on: Blogs.Accounts.Events.UserOnboarded,
    perform: Blogs.Accounts.Commands.RequestFeedback
  )
end
