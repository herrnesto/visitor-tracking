defmodule VisitorTracking.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    belongs_to :user, VisitorTracking.Accounts.User
    field :firstname, :string
    field :lastname, :string
    field :zip, :string
    field :city, :string
    field :phone, :string

    timestamps()
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :firstname, :lastname, :zip, :city, :phone])
    |> validate_required([:user_id, :firstname, :lastname, :zip, :city, :phone])
    |> validate_format(
      :phone,
    ~r/\A\+\d+\z/,
    message: "invalid mobile number, must be of format +XXXXXXXXX"
    )
  end
end
