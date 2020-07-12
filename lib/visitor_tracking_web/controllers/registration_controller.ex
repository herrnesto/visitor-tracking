defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Accounts

  def new(conn, _) do
    changeset = Accounts.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, _user} ->
        redirect(conn, to: "/verify_email")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
