defmodule VisitorTrackingWeb.ScanController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Events}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    %{scanners: scanners} = event = Events.get_event_with_preloads(id)

    case conn.assigns.current_user in scanners do
      true ->
        render(conn, "index.html", %{event: event, api_url: get_api_url()})

      false ->
        conn
        |> put_flash(:error, "You are not a scanner for this event")
        |> redirect(to: "/events/#{id}")
    end
  end

  def user(conn, %{"uuid" => uuid}) do
    case Accounts.get_user_by(uuid: uuid) do
      nil -> render(conn, "error.json", error: "not_found")
      user -> render(conn, "user.json", user: user)
    end
  end

  def assign_visitor(conn, %{"event_id" => event_id, "uuid" => uuid}) do
    with user <- Accounts.get_user_by(uuid: uuid),
         event <- Events.get_event(event_id) do
      Events.assign_visitor(event, user)

      render(conn, "assiged_visitor.json", status: "ok", event: event, user: user)
    end
  end

  def event_infos(conn, %{"id" => event_id}) do
    event = Events.get_event!(event_id, conn.assigns.current_user.id)

    render(conn, "event_infos.json", %{
      status: "ok",
      event: event,
      visitors: Events.count_visitors(event.id)
    })
  end

  defp get_api_url do
    get_protocol() <> get_host() <> "/api"
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
