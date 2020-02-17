# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

url_host =
  System.get_env("URL_HOST") ||
    raise """
    environment variable URL_HOST is missing.
    For example: mydomain.com
    """

url_scheme =
  System.get_env("URL_SCHEME") ||
    raise """
    environment variable URL_SCHEME is missing.
    For example: http or https
    """

config :sowproject, Sowproject.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :sowproject, SowprojectWeb.Endpoint,
  url: [host: url_host, scheme: url_scheme],
  http: [
    port: String.to_integer(System.get_env("PORT") || "8080"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true

config :sowproject, Sowproject.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: System.fetch_env!("GMAIL_SMTP_USERNAME"),
  password: System.fetch_env!("GMAIL_SMTP_PASSWORD"),
  tls: :if_available,
  ssl: false,
  auth: :always,
  retries: 1,
  from: "support@app.scopeofwork.ai"
