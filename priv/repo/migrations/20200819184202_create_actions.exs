defmodule VisitorTracking.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :event_id, references(:events)
      add :user_id, references(:users)
      add :action, :string

      timestamps()
    end

    create index(:actions, :user_id)
    create index(:actions, :event_id)
  end
end
