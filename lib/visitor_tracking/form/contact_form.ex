defmodule VisitorTracking.Form.ContactForm do
  @moduledoc """
  The contact form module.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "contact_forms" do
    field :email, :string
    field :message, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(contact_form, attrs) do
    contact_form
    |> cast(attrs, [:name, :email, :message])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/@/)
  end
end
