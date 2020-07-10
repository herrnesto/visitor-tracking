defmodule VisitorTracking.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :email_verified, :boolean
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_confirmation(:password,
      required: true,
      message: "password and confirmation do not match"
    )
    |> hash_password()
  end

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
  end

  defp hash_password(changeset), do: changeset
end
