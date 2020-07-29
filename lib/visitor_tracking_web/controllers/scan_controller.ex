defmodule VisitorTrackingWeb.ScanController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Events}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, params) do
    event = Events.get_event(Map.get(params, "id"))
    render(conn, "index.html", event: event)
  end

  def user(conn, params) do
    user = Accounts.get_user(Map.get(params, "uuid"))
    render(conn, "user.json", user: user)
  end

  def assign_visitor(conn, params) do
    with user <- Accounts.get_user(Map.get(params, "uuid")),
         event <- Events.get_event(Map.get(params, "event_id")) do
      event
      |> Events.assign_visitor(user)

      render(conn, "assiged_visitor.json", %{status: "ok", event: event, user: user})
    end
  end
end
