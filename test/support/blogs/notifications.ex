defmodule Blogs.Notifications do
  @moduledoc false
  use Momo.Feature

  feature do
    models do
      Blogs.Notifications.Digest
    end
  end
end
