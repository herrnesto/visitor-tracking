defmodule VisitorTrackingWeb.SessionController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Accounts
  alias VisitorTrackingWeb.Plugs.Auth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> redirect(to: "/events")

      {:error, _} ->
        render(conn, "new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: "/login")
  end
end
