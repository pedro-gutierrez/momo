defmodule Blogs.Accounts.Mappings.CredentialExpiredFromCredential do
  @moduledoc false
  use Momo.Mapping

  alias Blogs.Accounts.Model.Credential
  alias Blogs.Accounts.Events.CredentialExpired

  mapping from: Credential, to: CredentialExpired do
    field :user_id, path: "user.id"
    field :type, path: "type"
  end
end
