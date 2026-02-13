defmodule Momo.AppTest do
  use Momo.DataCase

  alias Blogs.Values.UserEmail
  alias Blogs.Values.UserId

  describe "roles_from_context/1" do
    test "returns the roles from the context" do
      roles = [:admin]
      context = %{current_user: %{roles: roles}}

      assert {:ok, roles} == Blogs.App.roles_from_context(context)
    end

    test "returns an error if the path to the roles is not found in the context" do
      context = %{}

      assert {:error, :no_such_roles_path} == Blogs.App.roles_from_context(context)
    end
  end

  describe "shortest_path/2" do
    test "evaluates the shortest to an attribute" do
      assert [:body] == Blogs.App.get_shortest_path(:comment, :body)
    end

    test "evaluates the shortest to an ancestor" do
      assert [:author] == Blogs.App.get_shortest_path(:comment, :author)
    end

    test "evaluates the shortest to an attribute in a parent" do
      assert [:post, :locked] == Blogs.App.get_shortest_path(:comment, :locked)
    end

    test "evaluates the shortest to an attribute in an ancestor" do
      assert [:post, :blog, :public] == Blogs.App.get_shortest_path(:comment, :public)
    end
  end

  describe "paths/2" do
    test "returns all paths between an model and an ancestor" do
      assert [[:author], [:post, :author], [:post, :blog, :author]] ==
               Blogs.App.get_paths(:comment, :author)
    end
  end

  describe "map/3" do
    test "maps input to output value using mappings" do
      input = %{id: "1"}
      assert {:ok, user_id} = Blogs.App.map(Map, UserId, input)
      assert user_id.__struct__ == UserId
      assert user_id.user_id == "1"
    end

    test "maps multiple items when using mappings" do
      inputs = [%{id: "1"}, %{id: "2"}]
      assert {:ok, [user_id1, user_id2]} = Blogs.App.map(Map, UserId, inputs)
      assert user_id1.__struct__ == UserId
      assert user_id1.user_id == "1"
      assert user_id2.__struct__ == UserId
      assert user_id2.user_id == "2"
    end

    test "validates the output when using mappings" do
      input = %{id: 1}
      assert {:error, reason} = Blogs.App.map(Map, UserId, input)
      assert errors_on(reason) == %{user_id: ["is invalid"]}
    end

    test "maps input to output value also when not using mappings" do
      input = %{email: "foo@bar"}
      assert {:ok, user_email} = Blogs.App.map(Map, UserEmail, input)
      assert user_email.__struct__ == UserEmail
      assert user_email.email == "foo@bar"
    end

    test "maps multiple inputs when not using mappings" do
      inputs = [%{email: "foo@bar"}, %{email: "bar@bar"}]
      assert {:ok, [user_email1, user_email2]} = Blogs.App.map(Map, UserEmail, inputs)
      assert user_email1.__struct__ == UserEmail
      assert user_email1.email == "foo@bar"
      assert user_email2.__struct__ == UserEmail
      assert user_email2.email == "bar@bar"
    end

    test "validate the output even if a mapping is not defined" do
      input = %{email: 1}
      assert {:error, reason} = Blogs.App.map(Map, UserEmail, input)
      assert errors_on(reason) == %{email: ["is invalid"]}
    end
  end
end
