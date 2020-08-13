defmodule VisitorTrackingWeb.EventController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Events, Events.Event, Events.Rules}

  def index(conn, _params) do
    events = Events.list_events(conn.assigns.current_user.id)
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
    case Events.get_event!(id, conn.assigns.current_user.id) do
      nil ->
        conn
        |> put_flash(
          :error,
          "Nur der Veranstalter ist berechtigt, diese Veranstaltung anzusehen."
        )
        |> redirect(to: Routes.event_path(conn, :index))

      event ->
        render(conn, "show.html", %{event: event, visitors: Events.count_visitors(event.id)})
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

  def event_start(conn, %{"id" => id}) do
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
end
