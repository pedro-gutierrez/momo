defmodule Momo.Model.AttributeTest do
  use ExUnit.Case

  alias Blogs.Publishing.Blog
  alias Momo.Model.Attribute

  describe "models" do
    test "have a list of attributes" do
      for attr <- Blog.attributes() do
        assert {:ok, %Attribute{} = ^attr} = Blog.field(attr.name)
      end
    end
  end
end
