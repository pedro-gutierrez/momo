defmodule Blogs.Events.UserOnboarded do
  @moduledoc false
  use Momo.Event

  event do
    field :user_id, type: :id, required: true
  end
end
