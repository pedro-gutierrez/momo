defmodule Blogs.Accounts.Credential do
  use Momo.Model

  alias Blogs.Accounts.Enums.CredentialType

  model do
    attribute :name, kind: :string
    attribute :type, kind: :integer, in: CredentialType
    attribute :value, kind: :string
    attribute :enabled, kind: :boolean

    belongs_to Blogs.Accounts.User

    unique fields: [:user, :name] do
      on_conflict strategy: :merge
    end
  end
end
