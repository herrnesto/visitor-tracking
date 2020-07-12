defmodule VisitorTracking.Twilio.Responses do
  @moduledoc """
  Handle Twilio API responses.
  """
  alias VisitorTracking.Repo
  alias VisitorTracking.Twilio.Responses.Response

  import Ecto.Query

  @doc """
  Log the response in the database.
  """
  def log(response, args) do
    IO.inspect(response.request)

    %Response{}
    |> Response.changeset(%{args: args, body: response.body, status_code: response.status_code})
    |> Repo.insert()
  end
end
