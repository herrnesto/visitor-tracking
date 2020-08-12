defmodule VisitorTracking.Events.Event do
  @moduledoc """
  User Schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias VisitorTracking.Accounts.User

  schema "events" do
    belongs_to :organiser, User
    field :closed, :boolean, default: false
    field :date_start, :naive_datetime
    field :name, :string
    field :status, :string
    field :venue, :string
    field :visitor_limit, :integer

    many_to_many :scanners, User, join_through: "event_scanners"

    many_to_many(
      :visitors,
      User,
      join_through: "events_visitors",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :organiser_id,
      :name,
      :venue,
      :status,
      :closed,
      :date_start,
      :visitor_limit
    ])
    |> validate_required([:organiser_id, :name, :venue, :date_start, :visitor_limit])
  end

  @doc false
  def changeset_organiser(event, %{id: organiser_id} = _args) do
    event
    |> cast(%{organiser_id: organiser_id}, [:organiser_id])
    |> validate_required([:organiser_id])
  end

  @doc false
  def changeset_visitor(event, visitor) do
    event
    |> cast(%{}, [])
    |> put_assoc(:visitors, [visitor | event.visitors])
  end
end
