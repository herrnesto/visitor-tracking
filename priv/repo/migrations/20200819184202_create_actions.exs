defmodule VisitorTracking.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:event_visitor_actions) do
      add :event_id, references(:events)
      add :user_id, references(:users)
      add :action, :string

      timestamps()
    end

    create index(:event_visitor_actions, :user_id)
    create index(:event_visitor_actions, :event_id)
  end
end
