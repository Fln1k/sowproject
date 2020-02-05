defmodule Sowproject.Repo do
  use Ecto.Repo,
    otp_app: :sowproject,
    adapter: Ecto.Adapters.Postgres
end
