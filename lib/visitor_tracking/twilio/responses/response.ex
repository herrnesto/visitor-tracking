defmodule VisitorTracking.Twilio.Responses.Response do
  @moduledoc """
  Ecto schema for Twilio responses for faster debugging.
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "twilio_response" do
    field :status_code, :integer
    field :args, :map
    field :body, :string
    timestamps()
  end

  def changeset(response, params) do
    response
    |> cast(params, [:args, :body, :status_code])
    |> validate_required([:args, :body, :status_code])
  end
end
