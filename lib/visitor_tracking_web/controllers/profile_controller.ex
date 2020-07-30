defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Verification}

  def expecting_verification(conn, _) do
    %{id: id, email: email} = conn.assigns.current_user

    {:ok, token} = Verification.create_link_token(id, email)

    Email.verification_email(email, token)
    |> Mailer.deliver_now()

    render(conn, "expecting_verification.html")
  end

  def new_token(conn, _) do
    case conn.assigns.current_user do
      nil ->
        redirect(conn, to: "/login")

      %{email_verified: true} ->
        conn
        |> put_flash(:info, "Bereits bestätigt")
        |> redirect(to: "/profile")

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
        |> put_flash(:info, "Deine E-Mail-Adresse wurde bestätigt.")
        |> redirect(to: "/profile")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/expecting_verification")
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
