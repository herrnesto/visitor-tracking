defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Twilio, Verification}

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
        |> put_flash(:info, "Profile created. Check your mobile for an sms with a code")
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
        |> put_flash(:error, status)
        |> render("phone_verification.html")

      error ->
        conn
        |> put_flash(:error, error)
        |> render("phone_verification.html")
    end
  end

  def verify_phone(conn, %{"code" => code}) do
    profile = conn.assigns.current_user.profile

    case Verification.verify_sms_code(code, profile.phone) do
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/profiles/phone_verification")

      {:ok, visitor_id} ->
        Accounts.verify_phone(visitor_id)

        conn
        |> put_flash(:info, "Phone Verified!")
        |> redirect(to: "/events")
    end
  end

  def show_qr(conn, _params) do
    render(conn, "show_qr.html", qrcode: generate_qrcode(11))
  end

  defp generate_qrcode(id) do
    data =
      id
      |> Integer.to_string()
      |> EQRCode.encode()
      |> EQRCode.png()
      |> Base.encode64()

    "data:image/png;base64," <> data
  end
end
