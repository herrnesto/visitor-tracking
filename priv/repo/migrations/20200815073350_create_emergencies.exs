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
  end
end
