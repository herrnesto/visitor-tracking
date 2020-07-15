defmodule VisitorTracking.Repo.Migrations.AddUuidToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :uuid, :string, null: false
    end

    create unique_index("users", :uuid)
  end
end
