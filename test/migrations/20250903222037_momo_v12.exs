defmodule Momo.Migration.V12 do
  use Ecto.Migration

  def up do
    alter(table(:credentials, prefix: :accounts)) do
      add(:type, :integer, null: false)
    end
  end

  def down do
    []
  end
end