defmodule VisitorTracking.Events do
  @moduledoc """
  Events Context module
  """
  alias VisitorTracking.{
    Accounts,
    Events.Event,
    Events.Scanner,
    Events.Visitor,
    Events.Rules,
    Repo
  }

  import Ecto.Query

  def get_event(id) do
    Repo.get(Event, id)
  end

  def get_event_with_preloads(id) do
    Event
    |> Repo.get(id)
    |> Repo.preload([:organiser, :scanners])
  end

  def assign_organiser(event, user) do
    event
    |> Event.changeset_organiser(user)
    |> Repo.update()
  end

  def assign_visitor(event, %Accounts.User{} = user) do
    %Visitor{}
    |> Visitor.changeset(%{event_id: event.id, user_id: user.id})
    |> Repo.insert()
  end

  def count_visitors(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> count_visitors()
  end

  def count_visitors(id) do
    Repo.one(from e in "events_visitors", where: e.event_id == ^id, select: count(e.event_id))
  end

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(user_id) do
    Repo.all(from p in Event, where: p.organiser_id == ^user_id)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(event_id, user_id), do: Repo.get_by(Event, id: event_id, organiser_id: user_id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    {:ok, rule} = Rules.new()
    attrs = Map.put(attrs, "status", rule.state)

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def list_scanners(event_id) do
    (s in Scanner)
    |> from()
    |> where([s], s.event_id == ^event_id)
    |> Repo.all()
    |> Repo.preload([:event, :user])
  end

  def add_scanner(event_id, phone) do
    case Accounts.get_user_by(phone: phone) do
      %Accounts.User{id: user_id} ->
        changeset = Scanner.changeset(%Scanner{}, %{user_id: user_id, event_id: event_id})
        scanner = Repo.insert(changeset)
        {:ok, scanner}

      nil ->
        {:error, "User does not exist"}
    end
  end
end
