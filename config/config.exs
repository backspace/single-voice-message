# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :single_voice_message, SingleVoiceMessageWeb.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "hZKMnq8sk7bp5aJ9S6MZ1yDedDHzlBlkPfrSYWHTnoI9wTmZA8ejy/H27MMF/aGa",
  render_errors: [accepts: ~w(html json)],
  pubsub_server: SingleVoiceMessage.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :json_library, Jason

config :single_voice_message, ecto_repos: [SingleVoiceMessage.Repo]
