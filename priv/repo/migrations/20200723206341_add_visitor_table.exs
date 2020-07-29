defmodule VisitorTracking.Repo.Migrations.AddVisitorTable do
  use Ecto.Migration

  def change do
    create table(:events_visitors, primary_key: false) do
      add :event_id, references(:events, on_delete: :delete_all), primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :inserted_at, :utc_datetime, default: fragment("NOW()")
    end

    create index(:events_visitors, [:event_id])
    create index(:events_visitors, [:user_id])

    create unique_index(:events_visitors, [:event_id, :user_id],
             name: :event_id_user_id_unique_index
           )
  end
end
