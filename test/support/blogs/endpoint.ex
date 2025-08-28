defmodule Blogs.Endpoint do
  @moduledoc false
  use Momo.Endpoint, otp_app: :momo

  endpoint do
    mount Blogs.Api, at: "/api"
    mount Blogs.Ui, at: "/"
  end
end
