defmodule Blogs.Ui do
  @moduledoc false
  use Momo.Ui

  ui do
    namespaces do
      Blogs.Ui.Namespaces.Root
    end
  end
end
