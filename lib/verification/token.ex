defmodule VisitorTracking.Verification.Token do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tokens" do
    # TODO
    # belongs_to :visitor, Visitor
    field :visitor_id, :integer
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
    |> validate_format(
      :email,
      ~r/\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/,
      message: "invalid E-Mail address"
    )
    |> validate_format(
      :mobile,
      ~r/\A\+\d+\z/,
      message: "invalid mobile number, must be of format +XXXXXXXXX"
    )
    |> unique_constraint(:token)
    |> unique_constraint([:code, :mobile])
  end
end