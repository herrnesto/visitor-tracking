defmodule VisitorTrackingWeb.EventView do
  use VisitorTrackingWeb, :view

  def event_organiser?(conn, event) do
    conn.assigns.current_user.id == event.organiser_id
  end
end
