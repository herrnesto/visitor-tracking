defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Twilio, Verification}
  alias VisitorTrackingWeb.Plugs.Auth

  plug :redirect_if_phone_verified

  def phone_validation(conn, _) do
    render(conn, "phone_validation.html")
  end

  def new(conn, %{"phone" => phone}) do
    phone = String.replace(phone, " ", "")

    with :phone_verified <- Twilio.validate_phone(phone),
         nil <- Accounts.get_user_by(phone: phone),
         changeset <- Accounts.change_user() do
      render(conn, "new.html", changeset: changeset, phone: phone)
    else
      %Accounts.User{} ->
        conn
        |> put_flash(:error, "Du hast bereits einen Account. Bitte melde dich an!")
        |> redirect(to: "/login")

      :wrong_number ->
        conn
        |> put_flash(:error, "Du hast eine ungültige Nummer eingegeben.")
        |> redirect(to: "/phone_validation")

      _ ->
        conn
        |> put_flash(:error, "Unbekannter Fehler")
        |> redirect(to: "/phone_validation")
    end
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> redirect(to: "/phone_verification")

      {:error, changeset} ->
        phone = user_params["phone"]

        render(conn, "new.html", changeset: changeset, phone: phone)
    end
  end

  def verify_phone(conn, %{"code" => code}) do
    user = conn.assigns.current_user

    case Verification.verify_sms_code(code, user.phone) do
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/phone_verification")

      {:ok, visitor_id} ->
        Accounts.verify_phone(visitor_id)

        Twilio.send_qr(%{uuid: user.uuid, target_number: user.phone})

        conn
        |> put_flash(:info, "Mobilnummer bestätigt!")
        |> redirect(to: "/profile")
    end
  end

  def phone_verification(conn, _) do
    user = conn.assigns.current_user

    with {:ok, token} <- Verification.create_sms_code(user.id, user.phone),
         {:ok, _} <- Twilio.send_token(%{token: token, target_number: user.phone}) do
      {:ok, link} = Verification.create_link_token(user.id, user.email)

      user.email
      |> Email.verification_email(link)
      |> Mailer.deliver_now()

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
        |> redirect(to: "/profile")
        |> halt()

      _ ->
        conn
    end
  end
end
