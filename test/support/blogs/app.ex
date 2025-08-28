defmodule Blogs.App do
  @moduledoc false
  use Momo.App, otp_app: :momo

  app roles: "current_user.roles" do
    features do
      Blogs.Accounts
      Blogs.Notifications
      Blogs.Publishing
    end
  end
end
