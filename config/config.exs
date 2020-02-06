# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sowproject,
  ecto_repos: [Sowproject.Repo]

# Configures the endpoint
config :sowproject, SowprojectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DfnWeWzNLqeF41PNjfTfNYS1C9SQxUxTUywSzkwZOWx2tc5B5ehN+kBHofDR7Fc/",
  render_errors: [view: SowprojectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sowproject.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian,
  issuer: "Sowproject.#{Mix.env()}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Sowproject.GuardianSerializer,
  secret_key: to_string(Mix.env()) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
