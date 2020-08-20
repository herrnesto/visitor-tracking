defmodule VisitorTrackingWeb.EventController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Events, Events.Event, Events.Rules}

  plug :check_if_organiser_or_scanner when action in [:show]

  plug :check_if_organiser
       when action in [:edit, :update, :start_event, :close_event, :delete]

  def index(conn, _params) do
    %{event_scanner: events} = Accounts.get_all_events_from_scanner(conn.assigns.current_user.id)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params
    |> Map.put("organiser_id", conn.assigns.current_user.id)
    |> Events.create_event()
    |> case do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Veranstaltung wurde erstellt.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Events.get_event(id) do
      nil ->
        conn
        |> put_flash(
          :error,
          "Nur der Veranstalter ist berechtigt, diese Veranstaltung anzusehen."
        )
        |> redirect(to: Routes.event_path(conn, :index))

      event ->
        render(conn, "show.html", %{
          event: event,
          visitors: Events.get_visitors_stats(event.id),
          scanners: Events.list_scanners(id)
        })
    end
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id, conn.assigns.current_user.id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id, conn.assigns.current_user.id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id, conn.assigns.current_user.id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Veranstaltung wurde gelöscht.")
    |> redirect(to: Routes.event_path(conn, :index))
  end

  def start_event(conn, %{"id" => id}) do
    with event <- Events.get_event!(id, conn.assigns.current_user.id),
         {:ok, rule} <- Rules.check(Rules.from_event(event), :start_event),
         {:ok, _event} <- Events.update_event(event, %{"status" => rule.state}) do
      conn
      |> put_flash(:info, "Status verändert.")
      |> redirect(to: Routes.event_path(conn, :show, id))
    else
      :error ->
        conn
        |> put_flash(:error, "Not allowed.")
        |> redirect(to: Routes.event_path(conn, :show, id))
    end
  end

  def close_event(conn, %{"id" => id}) do
    with event <- Events.get_event!(id, conn.assigns.current_user.id),
         {:ok, rule} <- Rules.check(Rules.from_event(event), :close_event),
         {:ok, _event} <- Events.update_event(event, %{"status" => rule.state}) do
      conn
      |> put_flash(:info, "Status verändert.")
      |> redirect(to: Routes.event_path(conn, :show, id))
    else
      :error ->
        conn
        |> put_flash(:error, "Not allowed.")
        |> redirect(to: Routes.event_path(conn, :show, id))
    end
  end

  defp check_if_organiser_or_scanner(conn, _params) do
    case is_scanner?(conn) || is_organiser?(conn) do
      true ->
        conn

      false ->
        conn
        |> redirect(to: "/events")
        |> halt()
    end
  end

  defp check_if_organiser(conn, _params) do
    case is_organiser?(conn) do
      true ->
        conn

      false ->
        conn
        |> redirect(to: "/events")
        |> halt()
    end
  end

  defp is_scanner?(%{params: %{"id" => event_id}} = conn) do
    with %{scanners: scanners} <- Events.get_event_with_preloads(event_id),
         user_id <- get_session(conn, :user_id),
         true <- user_in_scanners?(scanners, user_id) do
      true
    else
      _ ->
        false
    end
  end

  defp is_scanner?(_), do: false

  defp is_organiser?(%{params: %{"id" => event_id}} = conn) do
    case Events.get_event!(event_id, conn.assigns.current_user.id) do
      nil -> false
      _ -> true
    end
  end

  defp is_organiser?(_), do: false

  defp user_in_scanners?(scanners, user_id) do
    Enum.any?(scanners, fn %{id: id} -> id == user_id end)
  end
end
