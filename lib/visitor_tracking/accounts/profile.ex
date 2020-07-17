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
    field :phone, :string
    field :phone_verified, :boolean, default: false

    timestamps()
  end

  def changeset(profile, attrs) do
    attrs = clean_phone_number(attrs)

    profile
    |> cast(attrs, [:user_id, :firstname, :lastname, :zip, :city, :phone])
    |> validate_required([:user_id, :firstname, :lastname, :zip, :city, :phone])
    |> validate_length(:phone, is: 12)
    |> validate_length(:zip, is: 4)
    |> validate_format(
      :phone,
      ~r/\A\+\d+\z/,
      message: "invalid mobile number, must be of format +XXXXXXXXX"
    )
  end

  def phone_verification_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:phone_verified])
    |> validate_required([:phone_verified])
  end

  defp clean_phone_number(%{"phone" => phone} = attrs) do
    phone = String.replace(phone, " ", "")

    attrs
    |> Map.put("phone", phone)
  end

  defp clean_phone_number(attrs), do: attrs
end
