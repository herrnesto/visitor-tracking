defmodule VisitorTracking.Password.Token do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "password_tokens" do
    field :token, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    attrs = clean_phone_number(attrs)

    token
    |> cast(attrs, [:token, :phone])
    |> validate_required([:token, :phone])
    |> unique_constraint(:token)
  end

  defp clean_phone_number(%{"phone" => phone} = attrs) do
    phone = String.replace(phone, " ", "")

    Map.put(attrs, "phone", phone)
  end

  defp clean_phone_number(attrs), do: attrs
end
