defmodule TimeTrackerLive.Repo do
  use Ecto.Repo,
    otp_app: :time_tracker_live,
    adapter: Ecto.Adapters.Postgres
end
