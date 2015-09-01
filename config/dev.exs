use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :parcelmagic, Parcelmagic.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  cache_static_lookup: false,
  watchers: []

# Watch static and templates for browser reloading.
config :parcelmagic, Parcelmagic.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :parcelmagic, easypost_endpoint: "https://api.easypost.com/v2/",
                     easypost_key: "Test Key"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :parcelmagic, Parcelmagic.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "parcelmagic_dev",
  size: 10 # The amount of database connections in the pool
