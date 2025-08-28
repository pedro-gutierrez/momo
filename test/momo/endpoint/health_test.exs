defmodule Momo.Endpoint.HealthTest do
  use Momo.DataCase

  describe "an endpoint" do
    test "has a health check" do
      "/healthz"
      |> get()
      |> ok!()
    end
  end
end
