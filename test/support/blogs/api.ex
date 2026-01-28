defmodule Blogs.Api do
  @moduledoc false
  use Momo.Api

  api do
    plugs do
      Blogs.FakeAuth
    end

    features do
      Blogs
    end
  end
end
