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

config :visitor_tracking, :validator, VisitorTracking.Twilio.Validator

host = System.get_env("HOST") || "localhost:4000"

config :visitor_tracking,
  developer_tools: System.get_env("DEVELOPER_TOOLS") || true,
  host: host,
  protocol: "https://"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
