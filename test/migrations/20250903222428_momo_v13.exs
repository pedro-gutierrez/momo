defmodule Momo.Migration.V13 do
  use Ecto.Migration

  def up do
    alter(table(:onboardings, prefix: :accounts)) do
      add(:state, :string, null: true)
    end
  end

  def down do
    []
  end
end