defmodule VisitorTracking.Events.Visitor do
  @moduledoc """
  Connects a user with an event.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias VisitorTracking.Accounts.User
  alias VisitorTracking.Events.Event

  @primary_key false
  schema "events_visitors" do
    belongs_to :event, Event, primary_key: true
    belongs_to :user, User, primary_key: true
  end

  @required_fields ~w(event_id user_id)a
  def changeset(visitor, params \\ %{}) do
    visitor
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:event_id, :user_id],
      name: :events_visitors_pkey,
      message: "ALREADY_EXISTS"
    )
  end
end
