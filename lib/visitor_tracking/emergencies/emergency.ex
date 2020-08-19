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
    |> cast(attrs, [:recipient_name, :recipient_email])
    |> validate_required([:recipient_name, :recipient_email])
  end

  @doc false
  def changeset_additional_data(emergency, %{initiator_id: initiator_id, event_id: event_id} = _args) do
    emergency
    |> cast(%{initiator_id: initiator_id, event_id: event_id}, [:initiator_id, :event_id])
    |> validate_required([:initiator_id, :event_id])
  end
end
