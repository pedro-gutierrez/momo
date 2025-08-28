defmodule Momo.Migrations.AlterTableTest do
  use ExUnit.Case
  import MigrationHelper

  describe "migrations" do
    test "add columns to existing tables" do
      [
        """
        defmodule Momo.Migration.V1 do
          use Ecto.Migration

          def up do
            create table(:themes, prefix: :publishing, primary_key: false) do
            end
          end
        end
        """
      ]
      |> generate_migrations()
      |> assert_migrations([
        "alter(table(:themes, prefix: :publishing)) do",
        "add(:id, :binary_id, primary_key: true, null: false)",
        "add(:name, :string, null: false)"
      ])
    end

    test "drops columns from existing tables" do
      [
        """
        defmodule Momo.Migration.V1 do
          use Ecto.Migration

          def up do
            create table(:themes, prefix: :publishing, primary_key: false) do
              add(:id, :binary_id, primary_key: true, null: false)
              add(:name, :string, null: false)
              add(:closed, :boolean, null: true)
            end
          end
        end
        """
      ]
      |> generate_migrations()
      |> assert_migrations([
        "alter(table(:themes, prefix: :publishing)) do",
        "remove(:closed)"
      ])
    end

    test "does not add columns that exist already" do
      [
        """
        defmodule Momo.Migration.V1 do
          use Ecto.Migration

          def up do
            create(table(:themes, prefix: :publishing, primary_key: false)) do
            end
            alter(table(:themes, prefix: :publishing)) do
              add(:id, :binary_id, primary_key: true, null: false)
              add(:name, :string, null: false)
            end
          end
        end
        """
      ]
      |> generate_migrations()
      |> refute_migrations([
        "alter(table(:themes, prefix: :publishing)) do"
      ])
    end
  end
end
