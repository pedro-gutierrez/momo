defmodule Blogs.Subscriptions.UserRegistrations do
  @moduledoc false
  use Momo.Subscription

  subscription(
    on: Blogs.Events.UserRegistered,
    perform: Blogs.Flows.Onboarding
  )
end
