defmodule Blogs.Flows.Onboarding do
  @moduledoc false
  use Momo.Flow

  alias Blogs.Commands.SendWelcomeEmail
  alias Blogs.Commands.EnableUser

  alias Blogs.Onboarding
  alias Blogs.Values.UserId
  alias Blogs.Events.UserOnboarded

  flow model: Onboarding, params: UserId, publish: UserOnboarded do
    steps do
      SendWelcomeEmail
      EnableUser
    end
  end
end
