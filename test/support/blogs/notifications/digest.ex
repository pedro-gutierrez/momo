defmodule Blogs.Notifications.Digest do
  @moduledoc false
  use Momo.Model

  model virtual: true do
    attribute name: :text, kind: :string
    attribute name: :section, kind: :string
  end
end
