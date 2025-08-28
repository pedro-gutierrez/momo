defmodule Momo.ValueTest do
  use ExUnit.Case
  import Momo.ErrorsHelper

  alias Blogs.Accounts.Values.UserEmails
  alias Blogs.Accounts.Values.UserId

  describe "values" do
    test "don't have an id" do
      value = %UserId{user_id: "123"}
      refute Map.has_key?(value, :id)
    end

    test "can be encoded as json" do
      value = %UserId{user_id: "123"}
      assert %{"user_id" => "123"} == value |> Jason.encode!() |> Jason.decode!()
    end

    test "can be decoded from json" do
      assert {:ok, value} = UserId.decode("{ \"user_id\": \"123\"}")
      assert value == %UserId{user_id: "123"}
    end

    test "can be introspected" do
      assert {:ok, _} = UserId.field(:user_id)
      assert {:ok, _} = UserId.field("user_id")
    end
  end

  describe "validate/1" do
    test "validates a value" do
      params = %{"user_id" => "123"}

      assert {:ok, value} = UserId.validate(params)
      assert value.user_id == "123"
    end

    test "checks for required fields" do
      params = %{}

      assert {:error, changeset} = UserId.validate(params)
      assert errors_on(changeset) == %{user_id: ["can't be blank"]}
    end

    test "checks for fields of the wrong type" do
      params = %{"user_id" => 123}

      assert {:error, changeset} = UserId.validate(params)
      assert errors_on(changeset) == %{user_id: ["is invalid"]}
    end

    test "supports many values per field" do
      emails = ["a@b.com", "b@b.com"]
      params = %{"email" => emails}

      assert {:ok, value} = UserEmails.validate(params)
      assert value.email == emails
    end

    test "validates fields with many values" do
      params = %{"email" => nil}

      assert {:error, changeset} = UserEmails.validate(params)
      assert errors_on(changeset) == %{email: ["can't be blank"]}
    end
  end
end
