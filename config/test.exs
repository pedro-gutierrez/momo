import Config

config :logger,
  level: :warning

config :logger, :console, metadata: [:reason]

config :momo, :ecto_repos, [Blogs.Repo]

config :momo, Blogs.Repo,
  url: "postgres://localhost/blogs_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test"

config :momo, Momo,
  repo: Blogs.Repo,
  endpoint: Blogs.Endpoint,
  app: Blogs.App

config :momo, Blogs.Endpoint, port: 80

config :momo, Oban,
  testing: :manual,
  engine: Oban.Engines.Basic,
  queues: [default: 1],
  repo: Blogs.Repo
