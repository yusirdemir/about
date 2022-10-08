defmodule About.Repo do
  use Ecto.Repo,
    otp_app: :about,
    adapter: Ecto.Adapters.Postgres
end
