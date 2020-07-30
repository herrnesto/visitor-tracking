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
    field :date_end, :naive_datetime
    field :date_start, :naive_datetime
    field :description, :string
    field :name, :string
    field :status, :string
    field :venue, :string

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
    |> cast(attrs, [:organiser_id, :name, :venue, :description, :status, :closed, :date_start, :date_end])
    |> validate_required([:organiser_id, :name, :venue, :description, :date_start, :date_end])
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
