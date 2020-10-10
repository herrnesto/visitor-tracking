defmodule VisitorTracking.Password.Token do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "password_tokens" do
    field :token, :string
    field :mobile, :string
    field :valid, :boolean

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :mobile])
    |> validate_required([:token, :mobile])
    |> unique_constraint(:token)
  end
end
