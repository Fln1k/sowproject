use Mix.Config

# Configure your database
config :sowproject, Sowproject.Repo,
  url: System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost/sowproject_test",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sowproject, SowprojectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
