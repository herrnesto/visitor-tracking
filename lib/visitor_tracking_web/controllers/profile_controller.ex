defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Verification}

  plug :redirect_if_created, only: [:new]

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
        |> redirect(to: "/expecting_verification")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was a problem creating your profile")
        |> render("new.html", changeset: changeset)
    end
  end

  def expecting_verification(conn, _) do
    %{user_id: user_id, email: email} = conn.assigns.current_user.profile

    {:ok, token} = Verification.create_link_token(user_id, email)

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
      {:ok, user} ->
        user
        |> Email.qrcode_email(generate_qrcode(user.uuid))
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "Deine E-Mail-Adresse wurde bestätigt.")
        |> redirect(to: Routes.profile_path(conn, :new))

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

  defp redirect_if_created(conn, _) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> redirect(to: "/register")

      %{profile: nil} ->
        conn

      %{profile: profile} ->
        conn
        |> redirect(to: "/profiles/show")
        |> halt()
    end
  end
end
