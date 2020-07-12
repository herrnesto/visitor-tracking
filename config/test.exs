use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :visitor_tracking, VisitorTracking.Repo,
  username: "postgres",
  password: "postgress",
  database: "visitor_tracking_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  port: System.get_env("POSTGRES_PORT") || 5450,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :visitor_tracking, VisitorTrackingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :visitor_tracking, VisitorTracking.Mailer, adapter: Bamboo.TestAdapter

# Config pbkdf2 to take only one round for faster testing
config :pbkdf2_elixir, :rounds, 1

config :visitor_tracking,
  twilio_account_sid: "test",
  twilio_auth_token: "test",
  twilio_from: "+10000000000"
