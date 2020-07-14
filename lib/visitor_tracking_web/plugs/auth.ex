defmodule VisitorTrackingWeb.Plugs.Auth do
  @moduledoc """
  Authentication Plug module
  """

  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && VisitorTracking.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _params) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def check_email_verified(conn, _params) do
    if conn.assigns.current_user.email_verified do
      conn
    else
      conn
      |> put_flash(:error, "You must verify your email to proceed")
      |> redirect(to: "/expecting_verification")
      |> halt()
    end
  end

  def profile_created(conn, _params) do
    if conn.assigns.current_user.profile do
      conn
    else
      conn
      |> put_flash(:error, "You must create a profile to proceed")
      |> redirect(to: "/profiles/new")
      |> halt()
    end
  end

  def check_phone_verified(conn, _params) do
    if conn.assigns.current_user.profile.phone_verified do
      conn
    else
      conn
      |> put_flash(:error, "You must verify your phone to proceed")
      |> redirect(to: "/profiles/phone_verification")
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
