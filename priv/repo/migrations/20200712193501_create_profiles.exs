defmodule VisitorTracking.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, references(:users)
      add :firstname, :string
      add :lastname, :string
      add :zip, :string
      add :city, :string
      add :phone, :string

      timestamps()
    end
    create unique_index(:profiles, :user_id)
  end
end
