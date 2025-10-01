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
               {:get, "/blogs"}
             ] == routes
    end
  end
end
