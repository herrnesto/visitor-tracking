defmodule VisitorTracking.Repo.Migrations.CreateEmergencies do
  use Ecto.Migration

  def change do
    create table(:emergencies) do
      add :initiator_id, :integer
      add :event_id, :integer
      add :recipient_name, :string
      add :recipient_email, :string

      timestamps()
    end

    create index(:emergencies, [:initiator_id])
    create index(:emergencies, [:event_id])

    create unique_index(:emergencies, [:initiator_id, :event_id],
             name: :initiator_id_user_id_unique_index
           )
  end
end
