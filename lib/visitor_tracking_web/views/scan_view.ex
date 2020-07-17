defmodule VisitorTrackingWeb.ScanView do
  use VisitorTrackingWeb, :view

  def render("user.json", %{user: user}) do
    %{
      firstname: user.profile.firstname,
      lastname: user.profile.lastname,
      phone_verified: user.profile.phone_verified,
      email_verified: user.email_verified
    }
  end

  def render("assiged_visitor.json", %{status: status, event: event, user: user}) do
    %{
      status: status,
      event: %{event_id: event.id, event_name: event.name},
      user: %{
        firstname: user.profile.firstname,
        lastname: user.profile.lastname,
        phone_verified: user.profile.phone_verified,
        email_verified: user.email_verified
      }
    }
  end
end
