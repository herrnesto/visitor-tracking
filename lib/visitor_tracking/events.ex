defmodule VisitorTracking.Events do
  @moduledoc """
  Events Context module
  """
  alias VisitorTracking.Events.Event
  alias VisitorTracking.Accounts
  alias VisitorTracking.Repo

  def create(args \\ %{}) do
    %Event{}
    |> Event.changeset(args)
    |> Repo.insert()
  end

  def get_event(id) do
    Repo.get(Event, id)
  end

  def assign_organiser(event, user) do
    event
    |> Event.changeset_organiser(user)
    |> Repo.update()
  end

  def assign_visitor(event, %Accounts.User{} = user) do
    event
    |> Repo.preload(:visitors)
    |> Event.changeset_visitor(user)
    |> Repo.update()
  end
end
