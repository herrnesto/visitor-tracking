defmodule VisitorTrackingWeb.EventView do
  use VisitorTrackingWeb, :view

  use Timex

  def event_organiser?(conn, event) do
    conn.assigns.current_user.id == event.organiser_id
  end

  def datetime_convert(datetime) do
    datetime
    |> Timezone.convert("Europe/Zurich")
    |> Timex.format!("%Y-%m-%d um %R", :strftime)
  end
end
