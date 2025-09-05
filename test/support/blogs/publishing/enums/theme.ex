defmodule Blogs.Publishing.Enums.Theme do
  @moduledoc false
  use Momo.Enum

  enum do
    value "science", label: "Science"
    value "finance", label: "Finance"
  end
end
