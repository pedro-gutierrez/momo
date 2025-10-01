defmodule Blogs.Ui do
  @moduledoc false
  use Momo.Ui

  ui do
    namespaces do
      Blogs.Ui.Namespaces.Root
      Blogs.Ui.Namespaces.Admin
    end
  end
end
