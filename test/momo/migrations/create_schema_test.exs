defmodule Momo.Migrations.CreateSchemaTest do
  use ExUnit.Case
  import MigrationHelper

  describe "migrations" do
    test "create tables without schema prefixes" do
      migration = generate_migrations()
      assert migration =~ "create(table(:users, primary_key: false))"
      assert migration =~ "create(table(:credentials, primary_key: false))"
    end
  end
end
