defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Verification}

  def new(conn, _) do
    changeset = Accounts.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        {:ok, token} = Verification.create_link_token(user.id, user.email)
        Email.verification_email(user.email, token)

        redirect(conn, to: "/expecting_verification")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def expecting_verification(conn, _) do
    render(conn, "expecting_verification.html.eex")
  end

  def verify_email(conn, %{"token" => token}) do
    case Accounts.verify_email_by_token(token) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Email verified")
        |> redirect(to: "/create_profile")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Invalid token or token expired")
        |> render("/expecting_verification")
    end
  end
end
