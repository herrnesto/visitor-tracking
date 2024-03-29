defmodule VisitorTracking.Emergencies.Emergency do
  @moduledoc """
  Connects a user with an event.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias VisitorTracking.{Events.Event, Accounts.User}

  schema "emergencies" do
    belongs_to :initiator, User
    belongs_to :event, Event
    field :recipient_email, :string
    field :recipient_name, :string

    timestamps()
  end

  @required_fields ~w(recipient_name recipient_email initiator_id event_id)a
  def changeset(emergency, attrs) do
    emergency
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(
      :recipient_email,
      ~r/\A[\w.!\#$%&'*+\/=?^_`{|}~-]+@[\w](?:[\w-]{0,61}[\w])?(?:\.[\w](?:[\w-]{0,61}[\w])?)*\z/i,
      message: "invalid E-Mail address"
    )
    |> foreign_key_constraint(:initiator_id)
    |> foreign_key_constraint(:event_id)
    |> unique_constraint([:initiator_id, :event_id],
      name: :initiator_id_user_id_unique_index,
      message: "ALREADY_EXISTS"
    )
  end
end
