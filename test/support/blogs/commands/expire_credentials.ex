defmodule Blogs.Commands.ExpireCredentials do
  @moduledoc false
  use Momo.Command

  alias Blogs.Values.UserId
  alias Blogs.Models.Credential
  alias Blogs.Events.CredentialExpired

  command params: UserId, returns: Credential, many: true do
    publish event: CredentialExpired
  end

  def handle(params, _context) do
    credentials = [
      %Credential{
        id: Ecto.UUID.generate(),
        user_id: params.user_id,
        name: "password",
        type: 1,
        value: "password123",
        enabled: true
      },
      %Credential{
        id: Ecto.UUID.generate(),
        user_id: params.user_id,
        name: "pin",
        type: 2,
        value: "1234",
        enabled: true
      }
    ]

    {:ok, credentials}
  end
end
