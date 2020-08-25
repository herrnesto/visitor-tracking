defmodule VisitorTracking.Emergencies do
  @moduledoc """
  The Emergencies context.
  """

  import Ecto.Query, warn: false
  alias VisitorTracking.Repo

  alias VisitorTracking.Emergencies.Emergency

  def list_emergencies do
    Repo.all(Emergency)
  end

  def get_emergency!(id), do: Repo.get!(Emergency, id)

  def get_emergency_by_event_id(event_id) do
    Repo.get_by(Emergency, %{event_id: event_id})
  end

  def create_emergency(attrs \\ %{}) do
    %Emergency{}
    |> Emergency.changeset(attrs)
    |> Repo.insert()
  end

  def change_emergency(%Emergency{} = emergency, attrs \\ %{}) do
    Emergency.changeset(emergency, attrs)
  end
end
