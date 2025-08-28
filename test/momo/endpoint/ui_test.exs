defmodule Momo.Endpoint.UiTest do
  use Momo.DataCase

  describe "an endpoint" do
    test "routes requests to the ui" do
      resp =
        get("/")
        |> html_response!()

      assert resp =~ "DOCTYPE"
      assert resp =~ "Blogs Index Page"
      assert resp =~ "It works!"
    end
  end
end
