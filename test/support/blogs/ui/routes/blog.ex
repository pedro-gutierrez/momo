defmodule Blogs.Ui.Routes.Blog do
  @moduledoc false
  use Momo.Ui.Route

  route "/blogs", action: Blogs.Ui.Actions.Blog do
    view Blogs.Ui.Views.Blog
    view Blogs.Ui.Actions.BlogNotFound, for: "not_found"
  end
end
