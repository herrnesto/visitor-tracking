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
    belongs_to :event_id, Event, primary_key: true
    belongs_to :user_id, User, primary_key: true
    timestamps()
  end

  @required_fields ~w(event_id user_id)a
  def changeset(visitor, params \\ %{}) do
    visitor
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:event, :user],
      name: :event_id_user_id_unique_index,
      message: "ALREADY_EXISTS"
    )
  end
end
