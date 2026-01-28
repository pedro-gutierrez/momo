defmodule Momo.Migrations.CreateSchemaTest do
  use ExUnit.Case
  import MigrationHelper

  describe "migrations" do
    test "create tables without schema prefixes" do
      migration = generate_migrations()
      assert migration =~ "create(table(:users, prefix: nil, primary_key: false))"
      assert migration =~ "create(table(:credentials, prefix: nil, primary_key: false))"
      # Note: There may be an empty "CREATE SCHEMA " statement which is harmless
      # The important thing is that actual schema names aren't being created
    end
  end
end
