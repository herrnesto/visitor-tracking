defmodule VisitorTracking.Events.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "actions" do
    belongs_to :event, VisitorTracking.Events.Event
    belongs_to :user, VisitorTracking.Accounts.User
    field :action, :string

    timestamps()
  end

  def changeset(action, params) do
    action
    |> cast(params, [:event_id, :user_id, :action])
    |> validate_required([:event_id, :user_id, :action])
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:user_id)
  end
end
