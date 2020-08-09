defmodule VisitorTracking.Repo.Migrations.CreateEventScanners do
  use Ecto.Migration

  def change do
    create table(:event_scanners) do
      add :event_id, references(:events)
      add :user_id, references(:users)
      add :enabled, :boolean, default: true

      timestamps()
    end

    create unique_index(:event_scanners, [:event_id, :user_id])
  end
end
