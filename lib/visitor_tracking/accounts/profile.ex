defmodule VisitorTracking.Accounts.Profile do
  @moduledoc """
  Accounts Schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    belongs_to :user, VisitorTracking.Accounts.User

    timestamps()
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :firstname, :lastname, :zip, :city])
    |> validate_required([:user_id, :firstname, :lastname, :zip, :city])
  end
end
