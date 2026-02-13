defmodule Momo.Migrations.CreateIndexTest do
  use ExUnit.Case
  import MigrationHelper

  describe "migrations" do
    test "create indexes out of model keys" do
      migration = generate_migrations()

      assert migration =~
               "create(unique_index(:blogs, [:author_id, :name], name: :blogs_author_id_name_idx)"

      assert migration =~
               "create(unique_index(:themes, [:name], name: :themes_name_idx"
    end
  end
end
