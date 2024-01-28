use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :single_voice_message, SingleVoiceMessageWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :single_voice_message, SingleVoiceMessage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "single_voice_message_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :single_voice_message,
  twilio_account_sid: "AC123",
  pin: "12345",
  log_phone_number: "+12049832050"
