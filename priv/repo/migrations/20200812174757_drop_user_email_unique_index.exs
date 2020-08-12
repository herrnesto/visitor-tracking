defmodule VisitorTracking.Repo.Migrations.DropUserEmailUniqueIndex do
  use Ecto.Migration

  def change do
    drop unique_index(:users, :email)
  end
end
