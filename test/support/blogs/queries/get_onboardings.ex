defmodule Blogs.Queries.GetOnboardings do
  @moduledoc false
  use Momo.Query

  alias Blogs.Models.Onboarding

  query returns: Onboarding, many: true do
    sort by: :steps_pending, direction: :desc
  end
end
