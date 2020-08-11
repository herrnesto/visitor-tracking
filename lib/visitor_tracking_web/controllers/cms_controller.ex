defmodule VisitorTrackingWeb.CmsController do
  use VisitorTrackingWeb, :controller

  def homepage(conn, _) do
    render(conn, "homepage.html", [])
  end

  def privacy(conn, _) do
    render(conn, "privacy.html", [])
  end

  def howto(conn, _) do
    render(conn, "howto.html", [])
  end

  def prices(conn, _) do
    render(conn, "prices.html", [])
  end
end
