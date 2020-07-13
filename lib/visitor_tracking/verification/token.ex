defmodule VisitorTracking.Verification.Token do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias VisitorTracking.Accounts.User

  schema "tokens" do
    belongs_to :user, User
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
    |> cast(attrs, [:user_id, :type, :token, :code, :email, :mobile])
    |> validate_required([:user_id, :type])
    |> validate_inclusion(:type, ["sms", "link"])
    |> validate_format(:code, ~r/\A\d{6}\z/, message: "invalid code")
    |> validate_format(
      :mobile,
      ~r/\A\+\d+\z/,
      message: "invalid mobile number, must be of format +XXXXXXXXX"
    )
    |> unique_constraint(:token)
    |> unique_constraint([:code, :mobile])
  end
end
