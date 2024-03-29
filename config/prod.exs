use Mix.Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

host =
  System.get_env("HOST") ||
    raise """
    Host variable is missing.
    """

config :visitor_tracking, VisitorTrackingWeb.Endpoint,
  url: [host: host, port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: secret_key_base

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :visitor_tracking, VisitorTrackingWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :visitor_tracking, VisitorTrackingWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :visitor_tracking, VisitorTracking.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  pool_size: String.to_integer(System.get_env("DATABASE_PORT") || "5421")

twilio_account_sid = System.get_env("TWILIO_ACCOUNT_SID") || raise "Twilio account sid is missing"
twilio_auth_token = System.get_env("TWILIO_AUTH_TOKEN") || raise "Twilio auth token missing"
twilio_from = System.get_env("TWILIO_FROM") || raise "Twilio from number is missing"

config :visitor_tracking,
  twilio_account_sid: twilio_account_sid,
  twilio_auth_token: twilio_auth_token,
  twilio_from: twilio_from

# configure bamboo adapter by environment variable
bamboo_adapter =
  if System.get_env("DEVELOPER_TOOLS") == "true",
    do: Bamboo.TestAdapter,
    else: Bamboo.MailgunAdapter

mailgun_key = System.get_env("MAILGUN_KEY") || raise "SendGrid API key is missing"
mailgun_domain = System.get_env("MAILGUN_DOMAIN") || raise "SendGrid API key is missing"

config :visitor_tracking, VisitorTracking.Mailer,
  adapter: bamboo_adapter,
  api_key: mailgun_key,
  domain: mailgun_domain,
  base_uri: "https://api.eu.mailgun.net/v3",
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

sentry_dsn =
  System.get_env("SENTRY_DSN") ||
    raise """
    SENTRY_DSN variable is missing.
    """

config :sentry,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  dsn: sentry_dsn,
  included_environments: [:prod, "staging"],
  environment_name: System.get_env("RELEASE_LEVEL") || "development"

config :visitor_tracking,
  protocol: "https://"
