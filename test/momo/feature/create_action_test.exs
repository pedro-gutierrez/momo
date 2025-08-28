defmodule Momo.Feature.CreateActionTest do
  use Momo.DataCase

  alias Blogs.Publishing

  setup [:comments, :current_user]

  describe "create action" do
    test "requires an id", context do
      params = %{id: uuid(), name: "author"}
      ctx = guest(context).params

      assert {:ok, author} = Publishing.create_author(params, ctx)
      assert author.id == params.id
      assert author.name == params.name
    end

    test "requires parent relations", context do
      params = %{id: uuid(), name: "blog", published: true, author: context.author}
      ctx = author(context).params

      assert {:ok, blog} = Publishing.create_blog(params, ctx)
      assert blog.author_id == context.author.id
    end

    test "creates children too", context do
      author = context.author

      params = %{
        id: uuid(),
        name: "an elixir blog",
        published: true,
        author: author,
        posts: [
          %{
            id: uuid(),
            title: "some comment",
            author: author,
            published: true,
            locked: false,
            deleted: false
          }
        ]
      }

      ctx = author(context).params

      assert {:ok, _blog} = Publishing.create_blog(params, ctx)
    end

    test "returns unique contraints as validation errors", context do
      params = %{name: "blog", published: true, author: context.author}
      ctx = author(context).params

      assert {:ok, _} = Publishing.create_blog(params, ctx)
      assert {:error, error} = Publishing.create_blog(params, ctx)

      assert error
             |> errors_on()
             |> Map.values()
             |> List.flatten()
             |> Enum.member?("has already been taken")
    end

    test "merges entries on conflict", context do
      attrs = %{name: "science"}
      ctx = guest(context).params

      assert {:ok, theme1} = Publishing.create_theme(attrs, ctx)
      assert {:ok, theme2} = Publishing.create_theme(attrs, ctx)

      assert theme1.id == theme2.id
      assert theme1.name == theme2.name
    end
  end
end
