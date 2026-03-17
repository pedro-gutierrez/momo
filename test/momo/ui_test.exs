defmodule Momo.Ui.UiTest do
  use Momo.DataCase

  describe "ui" do
    test "uses default actions and views" do
      conn = :get |> new_conn("/") |> Blogs.Ui.call()

      assert conn.resp_body =~ "Blogs Index Page"
    end

    test "returns the list of routes sorted" do
      routes = Blogs.Ui.routes()

      assert [
               {:get, "/admin/"},
               {:get, "/"},
               {:get, "/blogs/:id"}
             ] == routes
    end

    test "routes requests" do
      assert visit("/admin") =~ "Admin Page"
      assert visit("/blogs/1") =~ "Welcome to my Blog 1"
      assert visit("/blogs/2") =~ "No such blog"
      assert visit("/") =~ "It works!"
    end
  end

  defp visit(path) do
    conn = :get |> new_conn(path) |> Blogs.Ui.call()
    conn.resp_body
  end
end
