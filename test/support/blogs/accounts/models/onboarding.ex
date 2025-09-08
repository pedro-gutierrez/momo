defmodule Blogs.Accounts.Onboarding do
  @moduledoc false
  use Momo.Model

  model do
    attribute :user_id, kind: :id, required: true
    attribute :steps_pending, kind: :integer, required: true
    attribute :state, kind: :string, required: false, computed: true

    unique fields: [:user_id] do
      on_conflict strategy: :merge
    end
  end
end
