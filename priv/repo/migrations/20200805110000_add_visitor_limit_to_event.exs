defmodule VisitorTracking.Repo.Migrations.AddVisitorLimitToEvents do
  use Ecto.Migration

  def change do
    alter table("events") do
      add :visitor_limit, :integer
    end
  end
end
