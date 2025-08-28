defmodule Momo.New.MixProject do
  use Mix.Project

  def project do
    [
      app: :momo_new,
      version: "0.0.3",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: [
          "Pedro Gutiérrez"
        ],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/pedro-gutierrez/momo"},
        files: ~w(lib mix.exs README.md),
        description: """
        Momo project generator.

        Provides a `mix momo.new` task to bootstrap a new Elixir application
        with Momo dependencies.
        """
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:eex, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0"}
    ]
  end
end
