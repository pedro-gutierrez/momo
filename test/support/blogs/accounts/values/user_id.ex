defmodule Blogs.Accounts.Values.UserId do
  @moduledoc false
  use Momo.Value

  value do
    field :user_id, type: :string
  end
end
