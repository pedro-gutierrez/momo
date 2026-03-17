defmodule Momo.Migration.V1 do
  use Ecto.Migration

  def up do
    Oban.Migration.up()

    create(table(:credentials, prefix: nil, primary_key: false)) do
      add(:enabled, :boolean, null: false)
      add(:id, :binary_id, primary_key: true, null: false)
      add(:name, :string, null: false)
      add(:type, :integer, null: false)
      add(:value, :string, null: false)
      add(:user_id, :binary_id, null: false)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:comments, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:body, :string, null: false)
      add(:author_id, :binary_id, null: false)
      add(:post_id, :binary_id, null: false)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:users, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:public, :boolean, default: false, null: false)
      add(:email, :string, null: false)
      add(:external_id, :binary_id, null: false)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:onboardings, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:state, :string, null: true)
      add(:user_id, :binary_id, null: false)
      add(:steps_pending, :integer, null: false)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:blogs, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:name, :string, null: false)
      add(:public, :boolean, default: false, null: true)
      add(:author_id, :binary_id, null: false)
      add(:published, :boolean, default: false, null: false)
      add(:theme_id, :binary_id, null: true)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:authors, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:name, :string, null: false)
      add(:profile, :string, default: "publisher", null: false)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:posts, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:title, :string, null: false)
      add(:author_id, :binary_id, null: false)
      add(:published, :boolean, default: false, null: false)
      add(:blog_id, :binary_id, null: false)
      add(:deleted, :boolean, default: false, null: false)
      add(:locked, :boolean, default: false, null: false)
      add(:published_at, :utc_datetime, null: true)
      timestamps(type: :utc_datetime_usec)
    end

    create(table(:themes, prefix: nil, primary_key: false)) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:name, :string, null: false)
      timestamps(type: :utc_datetime_usec)
    end

    alter(table(:blogs, prefix: nil)) do
      modify(:author_id, references(:authors, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:blogs, prefix: nil)) do
      modify(:theme_id, references(:themes, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:comments, prefix: nil)) do
      modify(:author_id, references(:authors, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:comments, prefix: nil)) do
      modify(:post_id, references(:posts, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:credentials, prefix: nil)) do
      modify(:user_id, references(:users, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:posts, prefix: nil)) do
      modify(:author_id, references(:authors, type: :binary_id, on_delete: :nothing))
    end

    alter(table(:posts, prefix: nil)) do
      modify(:blog_id, references(:blogs, type: :binary_id, on_delete: :nothing))
    end

    create(unique_index(:users, [:email], name: :users_email_idx, prefix: nil))

    create(
      unique_index(:credentials, [:user_id, :name],
        name: :credentials_user_id_name_idx,
        prefix: nil
      )
    )

    create(unique_index(:onboardings, [:user_id], name: :onboardings_user_id_idx, prefix: nil))

    create(
      unique_index(:blogs, [:author_id, :name], name: :blogs_author_id_name_idx, prefix: nil)
    )

    create(unique_index(:themes, [:name], name: :themes_name_idx, prefix: nil))
  end

  def down do
    []
  end
end
