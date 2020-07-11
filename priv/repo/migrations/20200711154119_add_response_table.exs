defmodule VisitorTracking.Repo.Migrations.AddResponseTable do
  use Ecto.Migration

  def change do
    create table("twilio_response") do
      add(:status_code, :integer)
      add(:args, :map)
      add(:body, :text)

      timestamps()
    end
  end
end
