defmodule Twtr.Repo do
  use Ecto.Repo,
    otp_app: :twtr,
    adapter: Ecto.Adapters.Postgres
end
