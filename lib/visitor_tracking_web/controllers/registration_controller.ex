defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Twilio, Verification}
  alias VisitorTrackingWeb.Plugs.Auth

  plug :redirect_if_phone_verified

  def new(conn, _) do
    changeset = Accounts.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> redirect(to: "/phone_verification")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def verify_phone(conn, %{"code" => code}) do
    user = conn.assigns.current_user

    case Verification.verify_sms_code(code, user.phone) do
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/profiles/phone_verification")

      {:ok, visitor_id} ->
        Accounts.verify_phone(visitor_id)

        conn
        |> put_flash(:info, "Mobilnummer bestätigt!")
        |> redirect(to: Routes.profile_path(conn, :new))
    end
  end

  def phone_verification(conn, _) do
    user = conn.assigns.current_user

    with {:ok, token} <- Verification.create_sms_code(user.id, user.phone),
         {:ok, _} <- Twilio.send_token(%{token: token, target_number: user.phone}) do
      render(conn, "phone_verification.html")
    else
      {:error, status} ->
        conn
        |> put_flash(:error, "SMS Gateway Fehler (#{status})")
        |> render("phone_verification.html")

      error ->
        conn
        |> put_flash(:error, error)
        |> render("phone_verification.html")
    end
  end

  defp redirect_if_phone_verified(conn, _) do
    case conn.assigns.current_user do
      %{phone_verified: true} ->
        conn
        |> redirect(to: "/profiles/new")
        |> halt()

      _ ->
        conn
    end
  end
end
