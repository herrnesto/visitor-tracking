defmodule VisitorTrackingWeb.EventController do
  use VisitorTrackingWeb, :controller

  def index(conn, _) do
    render(conn, "index.html", [])
  end
end
