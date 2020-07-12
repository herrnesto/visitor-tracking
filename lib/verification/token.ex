defmodule VisitorTracking.Verification.Token do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "tokens" do
    belongs_to :visitor, VisitorTracking.Accounts.User
    field :type, :string
    field :token, :string
    field :email, :string
    field :code, :string
    field :mobile, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:visitor_id, :type, :token, :code, :email, :mobile])
    |> validate_required([:visitor_id, :type])
    |> validate_inclusion(:type, ["sms", "link"])
    |> validate_format(:code, ~r/\A\d{6}\z/, message: "invalid code")
    |> unique_constraint(:token)
    |> unique_constraint([:code, :mobile])
  end
end
