defmodule Blogs.Accounts.Computations.OnboardingState do
  @moduledoc false

  def execute(onboarding, _context) do
    state = if onboarding.steps_pending == 0, do: "finished", else: "in_progress"

    {:ok, state}
  end
end
