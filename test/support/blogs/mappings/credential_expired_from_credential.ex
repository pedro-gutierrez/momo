defmodule Blogs.Mappings.CredentialExpiredFromCredential do
  @moduledoc false
  use Momo.Mapping

  alias Blogs.Model.Credential
  alias Blogs.Events.CredentialExpired

  mapping from: Credential, to: CredentialExpired do
    field :user_id, path: "user.id"
    field :type, path: "type"
  end
end
