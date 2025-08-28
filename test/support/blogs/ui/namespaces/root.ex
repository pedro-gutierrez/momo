defmodule Blogs.Ui.Namespaces.Root do
  @moduledoc false
  use Momo.Ui.Namespace

  namespace "/" do
    routes do
      Blogs.Ui.Routes.Index
      Blogs.Ui.Routes.Blog
    end
  end
end
