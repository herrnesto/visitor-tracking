defmodule VisitorTracking.Repo.Migrations.CreateContactForms do
  use Ecto.Migration

  def change do
    create table(:contact_forms) do
      add :name, :string
      add :email, :string
      add :message, :string

      timestamps()
    end
  end
end
