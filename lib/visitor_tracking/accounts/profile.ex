defmodule VisitorTracking.Accounts.Profile do
  @moduledoc """
  Accounts Schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    belongs_to :user, VisitorTracking.Accounts.User
    field :firstname, :string
    field :lastname, :string
    field :zip, :string
    field :city, :string
    field :email, :string
    field :email_verified, :boolean

    timestamps()
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :firstname, :lastname, :zip, :city])
    |> validate_required([:user_id, :firstname, :lastname, :zip, :city])
    |> validate_length(:zip, is: 4)
    |> validate_format(
      :email,
    ~r/\A[\w.!\#$%&'*+\/=?^_`{|}~-]+@[\w](?:[\w-]{0,61}[\w])?(?:\.[\w](?:[\w-]{0,61}[\w])?)*\z/i,
      message: "invalid E-Mail address"
    )
    |> unique_constraint(:email)
  end

  def email_verification_changeset(user, attrs) do
    user
    |> cast(attrs, [:email_verified])
    |> validate_required([:email_verified])
  end
end
