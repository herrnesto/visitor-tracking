defmodule VisitorTracking.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :organiser_id, :integer
      add :name, :string
      add :venue, :string
      add :description, :string
      add :status, :string
      add :closed, :boolean, default: false, null: false
      add :date_start, :naive_datetime
      add :date_end, :naive_datetime

      timestamps()
    end
  end
end
