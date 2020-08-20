defmodule VisitorTrackingWeb.ScanView do
  use VisitorTrackingWeb, :view

  def render("error.json", %{error: _}) do
    %{
      status: "error",
      message: "not_found"
    }
  end

  def render("user.json", %{user: user, checkin: checkin}) do
    %{
      status: "ok",
      firstname: user.firstname,
      lastname: user.lastname,
      phone_verified: user.phone_verified,
      email_verified: user.email_verified,
      checkin: checkin
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
        venue: event.venue,
        visitor_limit: event.visitor_limit
      },
      visitors: visitors
    }
  end

  def render("insert_action.json", %{action: %{action: action}}) do
    %{
      status: "ok",
      action: action
    }
  end

  def render("insert_action_error.json", %{error: errors}) do
    %{
      status: "error",
      errors:
        Enum.map(errors, fn {key, {val, _}} ->
          %{key => val}
        end)
    }
  end
end
