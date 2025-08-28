# Add Momo to an existing Phoenix project

The `momo.new` installer generates a simple plug based project from scratch. However, if you already have a Phoenix project, it is quite straightforward to add Momo into it.

## Add momo to your mix dependencies

```elixir
def deps do
  [{:momo, "~> 0.4"}]
end
```

## Define a feature, and a model

At the very least, create both a feature and a model:

```elixir
# lib/my_app/accounts.ex
defmodule MyApp.Accounts do
  use Momo.Feature

  feature do
    models do
      MyApp.Accounts.User
    end
  end
end
```

```elixir
# lib/my_app/accounts/user.ex
defmodule MyApp.Accounts.User do
  use Momo.Model

  model do
    attribute :email, kind: :string
  end
end
```

## Configure momo

In your `config.exs`, let Momo know about your repo and your features:

```elixir
config :momo, Momo,
  repo: MyApp.Repo,
  features: [
    MyApp.Accounts
  ]
```

## Migrate your database

Generate migrations for your features and models with:

```bash
$ mix momo.gen.migrations
```

then migrate your database as usual with `mix ecto.migrate`.
