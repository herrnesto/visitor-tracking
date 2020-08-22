defmodule VisitorTracking.Emergencies.Emergency do
  use Ecto.Schema
  import Ecto.Changeset

  alias VisitorTracking.{Event, Accounts.User}

  schema "emergencies" do
    belongs_to :initiator, User
    belongs_to :event, Event
    field :recipient_email, :string
    field :recipient_name, :string

    timestamps()
  end

  @doc false
  def changeset(emergency, attrs) do
    emergency
    |> cast(attrs, [:recipient_name, :recipient_email, :initiator_id, :event_id])
    |> validate_required([:recipient_name, :recipient_email, :initiator_id, :event_id])
    |> foreign_key_constraint(:initiator_id)
    |> foreign_key_constraint(:event_id)
    |> unique_constraint([:initiator_id, :event_id],
      name: :emergencies_pkey,
      message: "ALREADY_EXISTS"
    )
  end
end
