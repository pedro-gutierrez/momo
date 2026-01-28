defmodule Momo.QueryTest do
  use Momo.DataCase

  alias Blogs.User

  alias Blogs.Queries.{
    GetOnboardings,
    GetUsers,
    GetUserByEmail,
    GetUsersByEmails,
    GetUserIds
  }

  alias Blogs.Onboarding

  alias Blogs.Values.{
  UserId
  }

  alias Momo.Query

  describe "scope/1" do
    test "does not scope the query, if no policies are defined" do
      context = %{}
      query = GetOnboardings.scope(context)
      sql = to_sql(query)

      refute sql =~ "WHERE (FALSE)"
    end

    test "returns nothing, if the context does not have the expected roles path" do
      context = %{}
      query = GetUsers.scope(context)
      sql = to_sql(query)

      assert sql =~ "WHERE (FALSE)"
    end

    test "returns the original query, if no roles are defined in the context" do
      context = %{current_user: %{roles: []}}
      query = GetUsers.scope(context)
      sql = to_sql(query)

      refute sql =~ "WHERE"
    end

    test "returns nothing if roles are found in the context, but none match any of the policies" do
      context = %{current_user: %{roles: [:foo]}}
      query = GetUsers.scope(context)
      sql = to_sql(query)

      assert sql =~ "WHERE (FALSE)"
    end

    test "returns the original query if role matches, but has no scope" do
      context = %{current_user: %{roles: [:user]}}
      query = GetUserByEmail.scope(context)
      sql = to_sql(query)

      refute sql =~ "WHERE"
    end

    test "applies extra filters to queries according to scopes" do
      context = %{current_user: %{roles: [:guest]}}
      query = GetUsers.scope(context)
      sql = to_sql(query)

      assert sql =~ "WHERE (u0.\"public\" = $1)"
      refute sql =~ "WHERE (FALSE)"
    end
  end

  describe "execute/1" do
    test "is used when queries have no params" do
      context = %{}
      assert [item] = GetUserIds.execute(context)
      assert item.user_id
    end

    test "returns nothing, if no roles are present in the context" do
      {:ok, _} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          public: true,
          external_id: uuid()
        )

      context = %{}

      assert [] == GetUsers.execute(context)
    end

    test "applies scopes" do
      {:ok, _} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          public: true,
          external_id: uuid()
        )

      {:ok, _} =
        User.create(
          id: uuid(),
          email: "bar@bar",
          public: false,
          external_id: uuid()
        )

      context = %{current_user: %{roles: [:guest]}}
      assert [foo] = GetUsers.execute(context)
      assert foo.email == "foo@bar"
    end

    test "return validation errors on invalid parameters" do
      params = %{}
      context = %{}

      assert {:error, %Ecto.Changeset{} = errors} = GetUserByEmail.execute(params, context)
      assert errors_on(errors) == %{email: ["can't be blank"]}
    end

    test "can returns a single item" do
      {:ok, foo} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          public: true,
          external_id: uuid()
        )

      {:ok, _} =
        User.create(
          id: uuid(),
          email: "bar@bar",
          public: false,
          external_id: uuid()
        )

      params = %{"email" => foo.email}
      context = %{current_user: %{roles: [:user]}}

      assert {:ok, foo} = GetUserByEmail.execute(params, context)
      assert foo.email == "foo@bar"
    end


    test "returns an error if the item is not found" do
      params = %{"email" => "bar@bar"}
      context = %{current_user: %{roles: [:user]}}

      assert {:error, :not_found} = GetUserByEmail.execute(params, context)
    end

    test "accept keyword lists as parameters" do
      context = %{current_user: %{roles: [:user]}}
      params = [email: "bar@bar"]

      assert {:error, :not_found} = GetUserByEmail.execute(params, context)
    end

    test "can execute custom queries on read models" do
      context = %{}
      assert [item] = GetUserIds.execute(context)

      assert is_struct(item)
      assert item.__struct__ == UserId
      assert item.user_id
    end

    test "sorts results" do
      assert {:ok, o1} = Onboarding.create(id: uuid(), user_id: uuid(), steps_pending: 1)
      assert {:ok, o2} = Onboarding.create(id: uuid(), user_id: uuid(), steps_pending: 3)
      context = %{}

      assert [^o2, ^o1] = GetOnboardings.execute(context)
    end

    test "preloads associations by default" do
      {:ok, user} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          public: true,
          external_id: uuid()
        )

      params = %{"email" => user.email}
      context = %{current_user: %{roles: [:user]}}

      assert {:ok, user} = GetUserByEmail.execute(params, context)
      assert user.credentials == []
    end

    test "support lists of strings as parameters" do
      {:ok, _} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          public: true,
          external_id: uuid()
        )

      {:ok, _} =
        User.create(
          id: uuid(),
          email: "bar@bar",
          public: false,
          external_id: uuid()
        )

      context = %{current_user: %{roles: [:user]}}
      params = [email: ["foo@bar", "bar@bar"]]

      assert users = GetUsersByEmails.execute(params, context)
      assert length(users) == 2
    end

  end

  describe "apply_filters/2" do
    test "maps multivalued values to filters using the in operator" do
      params = %{email: ["a@b.com", "a@c.com"]}
      query = Query.apply_filters(User, GetUsersByEmails, params)
      sql = to_sql(query)

      assert sql =~ "WHERE (u0.\"email\" = ANY($1))"
    end
  end
end
