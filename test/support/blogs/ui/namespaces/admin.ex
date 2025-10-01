defmodule Blogs.Ui.Namespaces.Admin do
  @moduledoc false
  use Momo.Ui.Namespace

  namespace "/admin" do
    routes do
      Blogs.Ui.Routes.Admin
    end
  end
end
