defmodule VisitorTrackingWeb.CmsController do
  use VisitorTrackingWeb, :controller

  def homepage(conn, _) do
    render(conn, "homepage.html", [])
  end

  def privacy(conn, _) do
    render(conn, "privacy.html", [])
  end
end
