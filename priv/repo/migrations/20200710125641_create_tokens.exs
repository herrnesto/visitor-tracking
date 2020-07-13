defmodule VisitorTracking.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table("tokens") do
      # visitor_id will be replaced with user
      add :visitor_id, :integer, null: false
      add :type, :string, null: false
      add :token, :string
      add :email, :string
      add :code, :string
      add :mobile, :string
      timestamps()
    end

    create unique_index(:tokens, [:token])
    create unique_index(:tokens, [:code, :mobile])
  end
end
