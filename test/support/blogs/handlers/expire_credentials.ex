defmodule Blogs.Handlers.ExpireCredentials do
  @moduledoc false

  alias Blogs.Models.Credential

  def execute(params, _context) do
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
