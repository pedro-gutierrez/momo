defmodule Blogs.Accounts.Enums.CredentialType do
  @moduledoc false
  use Momo.Enum

  enum do
    value 1, label: "Password"
    value 2, label: "Pin"
  end
end
