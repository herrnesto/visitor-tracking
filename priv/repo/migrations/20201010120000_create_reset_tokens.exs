defmodule VisitorTracking.Repo.Migrations.CreatePasswordResetTokens do
  use Ecto.Migration

  def change do
    create table("password_tokens") do
      add :token, :string
      add :phone, :string
      timestamps()
    end

    create unique_index(:password_tokens, [:token])
  end
end
