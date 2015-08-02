use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :parcelmagic, Parcelmagic.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :parcelmagic, Parcelmagic.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "parcelmagic_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :parcelmagic, easypost_endpoint: "https://api.easypost.com/v2/",
                     easypost_key: "test_key##############",
