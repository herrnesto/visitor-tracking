defmodule VisitorTracking.Events.Event do
  @moduledoc """
  User Schema module
  """

  use Ecto.Schema

  alias VisitorTracking.Accounts.User

  schema "events" do
    belongs_to :organiser, User
    field :name, :string
    field :venue, :string
    field :date_start, :utc_datetime

    many_to_many(
      :users,
      User,
      join_through: "events_visitors",
      on_replace: :delete
    )
  end
end
