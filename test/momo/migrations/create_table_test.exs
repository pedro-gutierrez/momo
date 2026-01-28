defmodule Momo.Migrations.CreateTableTest do
  use ExUnit.Case
  import MigrationHelper

  describe "migrations" do
    test "create tables in the right context" do
      migrations = generate_migrations()
      assert migrations =~ "create(table(:blogs, prefix: nil"
      assert migrations =~ "create(table(:users, prefix: nil"
    end

    test "do not create tables if they already exist in the context" do
      existing = [
        """
        defmodule Momo.Migration.V1 do
          use Ecto.Migration

          def up do
            create table(:blogs, prefix: nil, primary_key: false) do
            end
            create table(:users, prefix: nil, primary_key: false) do
            end
          end
        end
        """
      ]

      migrations = generate_migrations(existing)
      refute migrations =~ "create(table(:blogs"
      refute migrations =~ "create(table(:users"
    end

    test "store timestamps as utc datetimes" do
      migrations = generate_migrations()
      assert migrations =~ "add(:published_at, :utc_datetime"
    end
  end
end
