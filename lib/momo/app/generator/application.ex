defmodule Momo.App.Generator.Application do
  @moduledoc false

  @behaviour Diesel.Generator

  @impl true
  def generate(app, opts) do
    name = app.name
    otp_app = Keyword.fetch!(opts, :otp_app)

    quote do
      use Application

      @otp_app unquote(otp_app)
      @repos unquote(app.repos)
      @endpoints unquote(app.endpoints)

      @migrate __MODULE__.Migrate

      def repos, do: @repos
      def repo, do: hd(@repos)
      def models, do: unquote(app.models)
      def commands, do: unquote(app.commands)
      def queries, do: unquote(app.queries)
      def events, do: unquote(app.events)
      def flows, do: unquote(app.flows)
      def subscriptions, do: unquote(app.subscriptions)
      def mappings, do: unquote(app.mappings)
      def values, do: unquote(app.values)
      def scopes, do: unquote(app.scopes)

      @impl true
      def start(_type, _args) do
        oban_config = Application.fetch_env!(@otp_app, Oban)

        extra = [
          @migrate,
          {Oban, oban_config}
        ]

        children = @repos ++ @endpoints ++ extra

        opts = [strategy: :one_for_one, name: unquote(name).Supervisor]
        Supervisor.start_link(children, opts)
      end
    end
  end
end
