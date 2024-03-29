defmodule SingleVoiceMessage.Mixfile do
  use Mix.Project

  def project do
    [app: :single_voice_message,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {SingleVoiceMessage, []}, extra_applications: [:logger, :phoenix, :phoenix_pubsub]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.5"},
     {:phoenix_pubsub, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 4.0"},
     {:ecto_sql, "~> 3.0"},
     {:jason, "~> 1.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix_view, "~> 2.0"},
     {:gettext, "~> 0.12"},
     {:plug_cowboy, "~> 2.1"},
     {:plug, "~> 1.7"},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:exml, "~> 0.1.3", only: :test}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
