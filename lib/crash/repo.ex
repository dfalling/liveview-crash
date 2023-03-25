defmodule Crash.Repo do
  use Ecto.Repo,
    otp_app: :crash,
    adapter: Ecto.Adapters.Postgres
end
