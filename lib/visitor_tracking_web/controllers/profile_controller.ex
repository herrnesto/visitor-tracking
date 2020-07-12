defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Accounts

  def new(conn, _) do
    user_id = get_session(conn, :user_id)
    changeset = Accounts.change_profile(user_id)
    render(conn, "new.html", changeset: changeset)
  end
end
