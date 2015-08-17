# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :parcelmagic, Parcelmagic.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "MEY/KVbylb2GnNLIQNWlUV8OcbbJH9FxVFYZPrQnskKHW/B7FvzzU7kzSrrgLKxH",
  render_errors: [default_format: "html"],
  pubsub: [name: Parcelmagic.PubSub,
           adapter: Phoenix.PubSub.PG2]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :joken,
  config_module: My.Config.Module
