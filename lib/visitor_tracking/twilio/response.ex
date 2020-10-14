defmodule VisitorTracking.Twilio.Response do
  @moduledoc """
  Handle Twilio API Response.
  """
  alias VisitorTracking.Repo
  alias VisitorTracking.Twilio.Response.Response

  @doc """
  Log the response in the database.
  """
  def log(response, args) do
    %Response{}
    |> Response.changeset(%{args: args, body: response.body, status_code: response.status_code})
    |> Repo.insert()
  end
end
