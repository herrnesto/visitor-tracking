defmodule VisitorTracking.Accounts.User do
  @moduledoc """
  User Schema module
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias VisitorTracking.Events.Event

  schema "users" do
    field :uuid, :string
    field :phone, :string
    field :phone_verified, :boolean, default: false
    field :firstname, :string
    field :lastname, :string
    field :zip, :string
    field :city, :string
    field :email, :string
    field :email_verified, :boolean
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"

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
    attrs = clean_phone_number(attrs)

    user
    |> cast(attrs, [
      :phone,
      :password,
      :password_confirmation,
      :uuid,
      :firstname,
      :lastname,
      :zip,
      :city,
      :email
    ])
    |> validate_required([
      :phone,
      :password,
      :password_confirmation,
      :uuid,
      :firstname,
      :lastname,
      :zip,
      :city,
      :email
    ], message: "Pflichtfeld")
    |> validate_length(:phone, min: 12, max: 13)
    |> validate_format(
      :phone,
      ~r/\A\+\d+\z/,
      message: "invalid mobile number, must be of format +00000000000"
    )
    |> validate_length(:zip, is: 4)
    |> validate_format(
      :email,
      ~r/\A[\w.!\#$%&'*+\/=?^_`{|}~-]+@[\w](?:[\w-]{0,61}[\w])?(?:\.[\w](?:[\w-]{0,61}[\w])?)*\z/i,
      message: "invalid E-Mail address"
    )
    |> unique_constraint(:phone)
    |> unique_constraint(:uuid)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password,
      required: true,
      message: "password and confirmation do not match"
    )
    |> hash_password()
  end

  def phone_verification_changeset(user, attrs) do
    user
    |> cast(attrs, [:phone_verified])
    |> validate_required([:phone_verified], message: "Pflichtfeld")
  end

  def email_verification_changeset(user, attrs) do
    user
    |> cast(attrs, [:email_verified])
    |> validate_required([:email_verified], message: "Pflichtfeld")
  end

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
  end

  defp hash_password(changeset), do: changeset

  defp clean_phone_number(%{"phone" => phone} = attrs) do
    phone = String.replace(phone, " ", "")

    Map.put(attrs, "phone", phone)
  end

  defp clean_phone_number(attrs), do: attrs
end
