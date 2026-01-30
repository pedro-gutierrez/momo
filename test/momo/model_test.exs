defmodule Momo.ModelTest do
  use Momo.DataCase

  alias Blogs
  alias Blogs.Models.{
  Author,
 Blog,
 Digest,
 User,
 Theme,
 Onboarding,
 Credential}

  alias Blogs.Queries.GetOnboardings

  describe "name/0" do
    test "return the atom representation of the model" do

      assert :blog == Blog.name()
    end
  end

  describe "field/1" do
    test "finds built-in fields" do
      assert {:ok, field} = User.field(:inserted_at)
      assert field.name == :inserted_at
    end
  end

  describe "attributes/0" do
    test "return  a list of attributes" do
      for attr <- Blog.attributes() do
        assert {:ok, %Momo.Model.Attribute{} = ^attr} = Blog.field(attr.name)
      end
    end

  end


  describe "keys/0" do
    test "returns composite keys" do
      assert [key] = Blog.keys()
      assert Blog == key.model
      assert [%Momo.Model.Relation{name: :author}, %Momo.Model.Attribute{name: :name}] = key.fields
      assert key.unique?
    end

    test "returns unique keys" do
      assert [key] = Theme.keys()
      assert key.unique?
    end
  end

  describe "primary_key/0" do
    test "returns its name and type" do
      pk = User.primary_key()
      assert :id == pk.name
      assert :id == pk.kind
      assert :binary_id == pk.storage
    end
  end

  describe "parents/0" do
    test "returns relations" do
      for rel <- Blog.parents() do
        assert {:ok, %Momo.Model.Relation{} = ^rel} = Blog.field(rel.name)
      end
    end
  end

  describe "virtual?/0" do
    test "returns whether the model is managed" do
      assert Digest.virtual?()
    end
  end

  describe "create/1" do
    test "creates models" do
      attrs = %{
        "id" => Ecto.UUID.generate(),
        "name" => "john"
      }

      assert {:ok, author} = Author.create(attrs)
      assert author.name == "john"
    end

    test "supports attributes as keyword lists" do
      assert {:ok, author} = Author.create(id: Ecto.UUID.generate(), name: "john")
      assert author.name == "john"
    end

    test "support attribute with atom keys" do
      attrs = %{
        id: Ecto.UUID.generate(),
        name: "john"
      }

      assert {:ok, author} = Author.create(attrs)
      assert author.name == "john"
    end


    test "validates inclusion of attribute values" do
      attrs = %{
        "id" => Ecto.UUID.generate(),
        "name" => "other"
      }

      assert {:error, changeset} = Theme.create(attrs)
      assert errors_on(changeset) == %{name: ["is invalid"]}
    end

    test "validates ids" do
      attrs = %{
        external_id: "1",
        email: "foo@bar.com",
        id: "2"
      }

      assert {:error, changeset} = User.create(attrs)

      assert errors_on(changeset) == %{
               external_id: ["is not a valid UUID"],
               id: ["is not a valid UUID"]
             }
    end



    test "allows timestamps to be manually modified" do
      two_days_ago = DateTime.utc_now() |> DateTime.add(-2 * 24 * 3600, :second)

      assert {:ok, user} =
               User.create(
                 id: uuid(),
                 email: "foo@bar",
                 external_id: uuid(),
                 public: true,
                 inserted_at: two_days_ago,
                 updated_at: two_days_ago
               )

      assert {:ok, user} = User.fetch(user.id)
      assert user.inserted_at == two_days_ago
      assert user.updated_at == two_days_ago
    end

    test "detects conflicts" do
      attrs = [
        id: Ecto.UUID.generate(),
        email: "foo@bar",
        public: true,
        external_id: Ecto.UUID.generate()
      ]

      assert {:ok, _onboarding} = User.create(attrs)

      assert {:error, errors} =
               attrs
               |> Keyword.put(:id, Ecto.UUID.generate())
               |> User.create()

      assert errors_on(errors) == %{email: ["has already been taken"]}
    end

    test "merges records on conflict when the strategy is set" do
      attrs = [
        user_id: Ecto.UUID.generate(),
        steps_pending: 1,
        id: Ecto.UUID.generate()
      ]

      assert {:ok, _onboarding} = Onboarding.create(attrs)

      assert {:ok, onboarding} =
               attrs
               |> Keyword.put(:id, Ecto.UUID.generate())
               |> Keyword.put(:steps_pending, 0)
               |> Onboarding.create()

      assert onboarding.user_id == attrs[:user_id]
      assert onboarding.steps_pending == 0
      assert onboarding.id == attrs[:id]
    end

    test "merges records when the unique key involves a parent relation" do
      assert {:ok, user} =
               User.create(
                 id: uuid(),
                 email: "foo@bar",
                 external_id: uuid(),
                 public: true
               )

      assert {:ok, cred1} =
               Credential.create(
                 user_id: user.id,
                 name: "password",
                 value: "foo",
                 enabled: true,
                 type: 1
               )

      assert {:ok, cred2} =
               Credential.create(
                 user_id: user.id,
                 name: "password",
                 value: "bar",
                 enabled: false,
                 type: 1
               )

      assert cred2.id == cred1.id
      assert cred2.name == "password"
      assert cred2.value == "bar"
      refute cred2.enabled

      assert {:ok, ^cred2} = Blogs.Models.Credential.fetch(cred1.id)
    end

    test "executes computations on fields" do
      assert {:ok, onboarding} = Onboarding.create(id: uuid(), user_id: uuid(), steps_pending: 2)

      assert onboarding.state == "in_progress"
    end
  end

  describe "create_many/1" do
    test "creates many models at once" do
      authors = [%{name: "a1", profile: "publisher"}, %{name: "a2", profile: "publisher"}]

      assert :ok = Author.create_many(authors)
    end

    test "merges records on conflict when the strategy is set" do
      user_id = uuid()

      onboarding1 = [
        id: uuid(),
        user_id: user_id,
        steps_pending: 2
      ]

      onboarding2 = [
        id: uuid(),
        user_id: user_id,
        steps_pending: 3
      ]

      assert :ok = Onboarding.create_many([onboarding1])
      assert :ok = Onboarding.create_many([onboarding2])

      assert [onboarding] = GetOnboardings.execute()
      assert onboarding.steps_pending == 3
    end
  end

  describe "read functions" do
    test "preload children relation when the option is set" do
      {:ok, user} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          external_id: uuid(),
          public: true
        )

      assert {:ok, user} = User.fetch(user.id)
      assert user.credentials == []

      assert [user] = User.list()
      assert user.credentials == []
    end

    test "do not preload relations by default" do
      {:ok, user} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          external_id: uuid(),
          public: true
        )

      assert {:ok, credential} =
               Credential.create(
                 user_id: user.id,
                 name: "password",
                 value: "bar",
                 enabled: false,
                 type: 1
               )

      assert {:ok, credential} = Credential.fetch(credential.id)
      refute Ecto.assoc_loaded?(credential.user)

      assert [credential] = Credential.list()
      refute Ecto.assoc_loaded?(credential.user)
    end
  end

  describe "plain_map/1" do
    test "turns a model into a plain map with string keys" do
      {:ok, user} =
        User.create(
          id: uuid(),
          email: "foo@bar",
          external_id: uuid(),
          public: true
        )

      assert %{
               "email" => user.email,
               "external_id" => user.external_id,
               "id" => user.id,
               "inserted_at" => user.inserted_at,
               "public" => user.public,
               "updated_at" => user.updated_at
             } == User.plain_map(user)
    end
  end
end
