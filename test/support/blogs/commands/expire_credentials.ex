defmodule Blogs.Commands.ExpireCredentials do
  @moduledoc false
  use Momo.Command

  alias Blogs.Values.UserId
  alias Blogs.Models.Credential
  alias Blogs.Events.CredentialExpired

  command params: UserId,
          returns: Credential,
          many: true,
          handler: Blogs.Handlers.ExpireCredentials do
    publish event: CredentialExpired
  end
end
