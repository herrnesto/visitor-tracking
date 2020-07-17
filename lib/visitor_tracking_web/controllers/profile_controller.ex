defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Twilio, Verification}

  def new(conn, _) do
    user_id = get_session(conn, :user_id)
    changeset = Accounts.change_profile(user_id)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profile" => profile_params}) do
    profile_params = Map.put_new(profile_params, "user_id", conn.assigns.current_user.id)

    case Accounts.create_profile(profile_params) do
      {:ok, _profile} ->
        conn
        |> redirect(to: "/profiles/phone_verification")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was a problem creating your profile")
        |> render("new.html", changeset: changeset)
    end
  end

  def phone_verification(conn, _) do
    profile = conn.assigns.current_user.profile

    with {:ok, token} <- Verification.create_sms_code(profile.user_id, profile.phone),
         {:ok, _} <- Twilio.send_token(%{token: token, target_number: profile.phone}) do
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

  def verify_phone(conn, %{"code" => code}) do
    user = conn.assigns.current_user

    case Verification.verify_sms_code(code, user.profile.phone) do
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/profiles/phone_verification")

      {:ok, visitor_id} ->
        Accounts.verify_phone(visitor_id)

        user
        |> Email.qrcode_email(generate_qrcode(user.uuid))
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "Mobilnummer bestätigt!")
        |> redirect(to: Routes.profile_path(conn, :show))
    end
  end

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.html", %{user: user, qrcode: generate_qrcode(user.uuid)})
  end

  # or show a default error image
  defp generate_qrcode(nil), do: raise("to generate a qrcode we need a uuid for the user")

  defp generate_qrcode(uuid) do
    data =
      uuid
      |> EQRCode.encode()
      |> EQRCode.png()
      |> Base.encode64()

    "data:image/png;base64," <> data
  end
end
