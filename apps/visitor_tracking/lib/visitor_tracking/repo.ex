defmodule VisitorTracking.Repo do
  use Ecto.Repo,
    otp_app: :visitor_tracking,
    adapter: Ecto.Adapters.Postgres
end
