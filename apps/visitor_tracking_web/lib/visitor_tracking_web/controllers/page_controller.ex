defmodule VisitorTrackingWeb.PageController do
  use VisitorTrackingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
