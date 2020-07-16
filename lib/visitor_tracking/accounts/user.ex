defmodule VisitorTracking.Accounts.User do
  @moduledoc """
  User Schema module
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias VisitorTracking.Events.Event

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :email_verified, :boolean
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"
    field :uuid, :string

    many_to_many(
      :visited_events,
      VisitorTracking.Events.Event,
      join_through: "events_visitors",
      on_replace: :delete
    )

    has_many :organised_events, Event, foreign_key: :organiser_id

    has_one :profile, VisitorTracking.Accounts.Profile

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :uuid])
    |> validate_required([:email, :password, :password_confirmation, :uuid])
    |> validate_confirmation(:password,
      required: true,
      message: "password and confirmation do not match"
    )
    |> validate_format(
      :email,
      ~r/\A[\w.!\#$%&'*+\/=?^_`{|}~-]+@[\w](?:[\w-]{0,61}[\w])?(?:\.[\w](?:[\w-]{0,61}[\w])?)*\z/i,
      message: "invalid E-Mail address"
    )
    |> hash_password()
    |> unique_constraint(:email)
  end

  def email_verification_changeset(user, attrs) do
    user
    |> cast(attrs, [:email_verified])
    |> validate_required([:email_verified])
  end

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
  end

  defp hash_password(changeset), do: changeset
end
