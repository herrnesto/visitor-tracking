defmodule VisitorTracking.Repo.Migrations.AddEventTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :organiser_id, references(:users, on_delete: :delete_all)
      add :name, :string
      add :venue, :text
      add :date_start, :utc_datetime
      timestamps()
    end

    create index(:events, [:organiser_id])
  end
end
