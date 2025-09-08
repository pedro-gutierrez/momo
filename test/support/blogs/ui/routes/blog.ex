defmodule Blogs.Ui.Routes.Blog do
  @moduledoc false
  use Momo.Ui.Route

  route "/blogs" do
    view Blogs.Ui.Views.Blog
    view Blogs.Ui.Actions.BlogNotFound, for: "not_found"
  end

  def execute(%{"id" => "1"}), do: %{"id" => "1", "name" => "Blog"}
  def execute(_), do: {:error, :not_found}
end
