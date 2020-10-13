defmodule VisitorTrackingWeb.RegistrationController do
  use VisitorTrackingWeb, :controller

  use PhoenixMetaTags.TagController

  alias VisitorTracking.{Accounts, Email, Mailer, Twilio, Verification}
  alias VisitorTrackingWeb.Plugs.Auth

  plug :redirect_if_phone_verified

  def phone_validation(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Registiere dich jetzt! | Vesita",
      description: "Registriere dich und verifiziere deine Kontaktdaten.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("phone_validation.html")
  end

  def phone_confirmation(conn, %{"phone" => phone}) do
    changeset = Accounts.change_user()
    render(conn, "phone_confirm.html", changeset: changeset, phone: phone)
  end

  def new(conn, %{"phone" => phone}) do
    phone = String.replace(phone, " ", "")

    with :phone_verified <- Twilio.validate_phone(phone),
         nil <- Accounts.get_user_by(phone: phone),
         changeset <- Accounts.change_user() do
      render(conn, "new.html", changeset: changeset, phone: phone, api_url: get_api_uri())
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

        Twilio.send_qr(%{
          uri: get_uri(Routes.qr_path(conn, :show, user.uuid)),
          target_number: user.phone
        })

        send_email_verifictation(user)

        conn
        |> put_flash(:info, "Mobilnummer bestätigt!")
        |> redirect(to: "/profile")
    end
  end

  def phone_verification(conn, _) do
    user = conn.assigns.current_user

    with {:ok, token} <- Verification.create_sms_code(user.id, user.phone),
         {:ok, _} <-
           Twilio.send_token(%{
             uri: get_uri(Routes.registration_path(conn, :phone_verification, user.uuid)),
             token: token,
             target_number: user.phone
           }) do
      render(conn, "phone_verification.html", api_url: get_api_uri())
    else
      {:error, :wait_before_recreate} ->
        conn
        |> put_flash(
          :error,
          "Du kannst nur alle 5 Minuten einen Token anfordern. Bitte lade die Seite in wenigen Augenblicken neu."
        )
        |> render("phone_verification.html", api_url: get_api_uri())

      {:error, status} ->
        conn
        |> put_flash(:error, "SMS Gateway Fehler (#{status})")
        |> render("phone_verification.html", api_url: get_api_uri())

      error ->
        conn
        |> put_flash(:error, error)
        |> render("phone_verification.html", api_url: get_api_uri())
    end
  end

  def send_email_verifictation(user) do
    {:ok, token} = Verification.create_link_token(user.id, user.email)

    user.email
    |> Email.verification_email(token)
    |> Mailer.deliver_later()
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

  defp get_api_uri do
    get_protocol() <> get_host()
  end

  defp get_uri(path) do
    get_protocol() <> get_host() <> path
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
