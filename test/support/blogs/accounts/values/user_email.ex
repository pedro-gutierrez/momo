defmodule Blogs.Accounts.Values.UserEmail do
  @moduledoc false
  use Momo.Value

  value do
    field :email, type: :string
  end
end
