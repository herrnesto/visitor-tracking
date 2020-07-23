defmodule VisitorTracking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :string, null: false
      add :phone, :string, null: false
      add :password_hash, :string, null: false
      add :phone_verified, :boolean, default: false
      add :role, :string, default: "user"

      timestamps()
    end

    create unique_index("users", :uuid)
  end
end
