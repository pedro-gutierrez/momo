defmodule Momo.CommandTest do
  use Momo.DataCase

  alias Blogs.Commands.RegisterUser
  alias Blogs.Commands.RemindPassword
  alias Blogs.Models.User
  alias Blogs.Events.UserRegistered

  describe "allowed?/1" do
    test "always allows if the command has no policies" do
      context = %{current_user: %{roles: []}}

      assert RemindPassword.allowed?(context)
    end

    test "denies if no policies match the current subject" do
      context = %{current_user: %{roles: [:admin]}}

      refute RegisterUser.allowed?(context)
    end

    test "allows if the role is matched and no scope is defined" do
      context = %{current_user: %{roles: [:guest]}}

      assert RegisterUser.allowed?(context)
    end

    test "allows if the role is matched and the scope also matches" do
      context = %{
        current_user: %{id: 1, roles: [:user]},
        user: %{id: 1, locked: false}
      }

      assert RemindPassword.allowed?(context)
    end

    test "denies if the role is matched but the scope doesn't" do
      context = %{
        current_user: %{id: 1, roles: [:user]},
        user: %{id: 1, locked: true}
      }

      refute RemindPassword.allowed?(context)
    end
  end

  describe "execute/2" do
    test "applies authorization if the context is empty" do
      params = %User{id: uuid(), email: "test@gmail.com", external_id: uuid()}
      context = %{}

      assert {:error, :unauthorized} = RegisterUser.execute(params, context)
    end

    test "applies authorization based on policies" do
      params = %{email: "test@example.com", external_id: uuid(), id: uuid()}
      context = %{current_user: %{roles: [:admin]}}

      assert {:error, :unauthorized} == RegisterUser.execute(params, context)
      assert 0 == Blogs.Repo.aggregate(User, :count)

      refute_event_published(UserRegistered)
    end

    test "can skip authorization" do
      params = %User{id: uuid(), email: "test@gmail.com", external_id: uuid()}
      context = %{authorization: :skip}

      assert {:ok, user} = RegisterUser.execute(params, context)
      assert user.id == params.id
      assert user.email == params.email

      assert_event_published(UserRegistered)
    end

    test "does not publish events if explicit conditions are matched" do
      params = %{email: "fake@gmail.com", external_id: uuid(), id: uuid()}
      context = %{current_user: %{roles: [:guest]}}

      assert {:ok, _user} = RegisterUser.execute(params, context)
      refute_event_published(UserRegistered)
    end

    test "accepts value structs as parameters" do
      params = %User{email: "test@example.com", external_id: uuid(), id: uuid()}
      context = %{current_user: %{roles: [:guest]}}

      assert {:ok, _user} = RegisterUser.execute(params, context)
      refute_event_published(UserRegistered)
    end

    test "accepts keyword lists as parameters" do
      params = [email: "test@example.com", external_id: uuid(), id: uuid()]
      context = %{current_user: %{roles: [:guest]}}

      assert {:ok, _user} = RegisterUser.execute(params, context)
      refute_event_published(UserRegistered)
    end

    test "rollbacks the transaction if the command is atomic and the handler fails" do
      params = %{email: "foo@bar.com", external_id: uuid(), id: uuid()}
      context = %{current_user: %{roles: [:guest]}}

      assert {:error, :invalid_email} = RegisterUser.execute(params, context)
      assert 0 == Blogs.Repo.aggregate(User, :count)

      refute_event_published(UserRegistered)
    end
  end
end
