defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Verification}

  def new(conn, _) do
    changeset = Accounts.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:ok, token} = Verification.create_link_token(user.id, user.email)

        user.email
        |> Email.verification_email(token)
        |> Mailer.deliver_now()

        redirect(conn, to: "/expecting_verification")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def expecting_verification(conn, _) do
    render(conn, "expecting_verification.html")
  end

  def new_token(conn, _) do
    case conn.assigns.current_user do
      nil ->
        redirect(conn, to: "/login")

      %{email_verified: true} ->
        conn
        |> put_flash(:info, "Already verified")
        |> redirect(to: "/profiles")

      user ->
        {:ok, token} = Verification.create_link_token(user.id, user.email)

        user.email
        |> Email.verification_email(token)
        |> Mailer.deliver_now()

        redirect(conn, to: "/expecting_verification")
    end
  end

  def verify_email(conn, %{"token" => token}) do
    case Accounts.verify_email_by_token(token) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Email verified")
        |> redirect(to: "/profiles/new")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/expecting_verification")
    end
  end
end
