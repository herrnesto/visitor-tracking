# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :visitor_tracking,
  ecto_repos: [VisitorTracking.Repo]

config :visitor_tracking_web,
  ecto_repos: [VisitorTracking.Repo],
  generators: [context_app: :visitor_tracking]

# Configures the endpoint
config :visitor_tracking_web, VisitorTrackingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aBWX5lmsbLtwTzGAnvPDARqT+lJv3T1zcRuWxszS9YDcVY/Ht2HPZuXLhbWiTsNf",
  render_errors: [view: VisitorTrackingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VisitorTracking.PubSub,
  live_view: [signing_salt: "Mtym5xHL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"