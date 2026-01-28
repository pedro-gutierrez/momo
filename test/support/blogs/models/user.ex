defmodule Blogs.User do
  use Momo.Model

  model do
    attribute :email, kind: :string
    attribute :public, kind: :boolean, default: false
    attribute :external_id, kind: :id

    unique fields: [:email]

    has_many Blogs.Credential, preloaded: true
  end
end
