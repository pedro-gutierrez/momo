defmodule Blogs.Handlers.RegisterUser do
  @moduledoc false
  alias Blogs.Models.User

  def execute(%{email: "foo@bar.com"}, _context), do: {:error, :invalid_email}
  def execute(user, _context), do: User.create(user)
end
