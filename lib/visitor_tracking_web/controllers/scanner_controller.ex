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
        |> redirect(to: "/events/#{event_id}/scanners")

      {:error, reason} ->
        action = "/events/#{event_id}/scanners"

        conn
        |> put_flash(:error, reason)
        |> render("new.html", action: action, error: reason)
    end
  end
end
