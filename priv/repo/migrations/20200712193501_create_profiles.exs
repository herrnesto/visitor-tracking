defmodule VisitorTracking.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, references(:users)
      add :firstname, :string
      add :lastname, :string
      add :zip, :string
      add :city, :string
      add :email, :string
      add :email_verified, :boolean, default: false

      timestamps()
    end

    create unique_index(:profiles, :user_id)
    create unique_index(:profiles, :email)
  end
end
