defmodule VisitorTrackingWeb.CmsController do
  use VisitorTrackingWeb, :controller
  use PhoenixMetaTags.TagController

  def homepage(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Phoenix Title",
      description: "Phoenix Descriptions",
      url: "https://phoenix.meta.tags",
      image: "https://phoenix.meta.tags/logo.png"
    })
    |> render("homepage.html", [])
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
