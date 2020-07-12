defmodule VisitorTracking.Events.Event do
  @moduledoc """
  User Schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias VisitorTracking.Accounts.User
  alias VisitorTracking.Repo

  schema "events" do
    belongs_to :organiser, User
    field :name, :string
    field :venue, :string
    field :date_start, :utc_datetime

    many_to_many(
      :visitors,
      User,
      join_through: "events_visitors",
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(event, args) do
    event
    |> cast(args, [:name, :venue, :date_start])
    |> validate_required([:name, :venue, :date_start])
  end

  def changeset_organiser(event, %{id: organiser_id} = _args) do
    event
    |> cast(%{organiser_id: organiser_id}, [:organiser_id])
    |> validate_required([:organiser_id])
  end

  def changeset_visitor(event, visitor) do
    event
    |> cast(%{}, [])
    |> put_assoc(:visitors, [visitor | event.visitors])
  end
end
