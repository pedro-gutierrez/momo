defmodule Blogs.Models.Credential do
  use Momo.Model

  model do
    attribute :name, kind: :string
    attribute :type, kind: :integer, in: Blogs.Enums.CredentialType

    attribute :value, kind: :string
    attribute :enabled, kind: :boolean

    belongs_to Blogs.Models.User

    unique fields: [:user, :name] do
      on_conflict strategy: :merge
    end
  end
end
