defmodule VisitorTracking.Events.Scanner do
  @moduledoc """
  Scanner Schema Module for event_sfcanners table
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "event_scanners" do
    belongs_to :event, VisitorTracking.Events.Event
    belongs_to :user, VisitorTracking.Accounts.User
    field :enabled, :boolean

    timestamps()
  end

  def changeset(scanner, attrs) do
    scanner
    |> cast(attrs, [:event_id, :user_id])
    |> validate_required([:event_id, :user_id])
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:user_id)
  end
end
