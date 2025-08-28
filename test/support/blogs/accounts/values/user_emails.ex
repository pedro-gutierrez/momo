defmodule Blogs.Accounts.Values.UserEmails do
  @moduledoc false
  use Momo.Value

  value do
    field :email, type: :string, many: true
  end
end
