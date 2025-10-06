defmodule Blogs.Accounts.Events.CredentialExpired do
  @moduledoc false

  use Momo.Event

  event do
    field :user_id, type: :id
    field :type, type: :integer
  end
end
