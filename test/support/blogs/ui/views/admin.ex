defmodule Blogs.Ui.Views.Admin do
  @moduledoc false
  use Momo.Ui.View

  view do
    html do
      head do
        title "My Blog"
      end

      body do
        h1 "Admin Page"
      end
    end
  end
end
