defmodule VisitorTrackingWeb.ScannerController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Events

  def index(conn, %{"event_id" => event_id}) do
    scanners = Events.list_scanners(event_id)
    render(conn, "index.html", scanners: scanners, event_id: event_id)
  end

  def new(conn, %{"event_id" => event_id}) do
    action = Routes.scanner_path(conn, :create, event_id)
    render(conn, "new.html", action: action, error: nil)
  end

  def create(conn, %{"event_id" => event_id, "phone" => phone}) do
    phone = String.replace(phone, " ", "")

    case Events.add_scanner(event_id, phone) do
      {:ok, _scanner} ->
        conn
        |> put_flash(:info, "Scanner has been added")
        |> redirect(to: "/events/#{event_id}")

      {:error, reason} ->
        action = "/events/#{event_id}/scanners"

        conn
        |> put_flash(:error, reason)
        |> render("new.html", action: action, error: reason)
    end
  end

  def delete(conn, %{"id" => id, "event_id" => event_id}) do
    case Events.remove_scanner(String.to_integer(event_id), String.to_integer(id)) do
      :ok ->
        conn
        |> put_flash(:success, "Scanner wurde entfernt.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, "Organiser can not be removed as a scanner."} ->
        conn
        |> put_flash(:error, "Der Organisator kann nicht als Scanner entfernt werden.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, _} ->
        conn
        |> put_flash(:error, "Ein unbekannter Fehler ist aufgetreten.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))
    end
  end
end
