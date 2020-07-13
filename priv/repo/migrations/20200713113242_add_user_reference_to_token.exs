defmodule VisitorTracking.Repo.Migrations.AddUserReferenceToToken do
  use Ecto.Migration

  def change do
    alter table("tokens") do
      add :user_id, references(:users, on_delete: :delete_all)
      remove :visitor_id
    end
  end
end
