defmodule VisitorTrackingWeb.ScanView do
  use VisitorTrackingWeb, :view

  def render("error.json", %{error: error}) do
    %{
      status: "error",
      message: "not_found"
    }
  end

  def render("user.json", %{user: user}) do
    %{
      status: "ok",
      firstname: user.firstname,
      lastname: user.lastname,
      phone_verified: user.phone_verified,
      email_verified: user.email_verified
    }
  end

  def render("assiged_visitor.json", %{status: status, event: event, user: user}) do
    %{
      status: status,
      event: %{event_id: event.id, event_name: event.name},
      user: %{
        firstname: user.firstname,
        lastname: user.lastname,
        phone_verified: user.phone_verified,
        email_verified: user.email_verified
      }
    }
  end

  def render("event_infos.json", %{status: status, event: event, visitors: visitors}) do
    %{
      status: status,
      event: %{
        id: event.id,
        name: event.name,
        venue: event.venue
      },
      visitors: visitors
    }
  end
end
