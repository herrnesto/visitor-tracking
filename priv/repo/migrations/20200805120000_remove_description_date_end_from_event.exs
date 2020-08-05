defmodule VisitorTracking.Repo.Migrations.RemoveDescriptionDateEndFromEvent do
  use Ecto.Migration

  def change do
    alter table("events") do
      remove :date_end
      remove :description
    end
  end
end
