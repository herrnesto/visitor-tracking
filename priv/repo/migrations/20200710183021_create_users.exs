defmodule VisitorTracking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :string, null: false
      add :phone, :string, null: false
      add :password_hash, :string, null: false
      add :phone_verified, :boolean, default: false
      add :role, :string, default: "user"
      add :firstname, :string
      add :lastname, :string
      add :zip, :string
      add :city, :string
      add :email, :string
      add :email_verified, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, :uuid)
    create unique_index(:users, :phone)
    create unique_index(:users, :email)
  end
end
