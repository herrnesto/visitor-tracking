# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :visitor_tracking,
  ecto_repos: [VisitorTracking.Repo]

# Configures the endpoint
config :visitor_tracking, VisitorTrackingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TcdHqnS3dtFvzzl0FDL+E9G+cN+1a56DSTWh4eCXom6LDL/qhTWeGxaPoVtSf5dp",
  render_errors: [view: VisitorTrackingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VisitorTracking.PubSub,
  live_view: [signing_salt: "Ddpp4t0K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

twilio_account_sid = System.get_env("TWILIO_ACCOUNT_SID") || raise "Twilio account sid is missing"
twilio_auth_token = System.get_env("TWILIO_AUTH_TOKEN") || raise "Twilio auth token missing"
twilio_from = System.get_env("TWILIO_FROM") || raise "Twilio from number is missing"

config :visitor_tracking,
  twilio_account_sid: twilio_account_sid,
  twilio_auth_token: twilio_auth_token,
  twilio_from: twilio_from

config :visitor_tracking,
  developer_tools: System.get_env("DEVELOPER_TOOLS") || true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
