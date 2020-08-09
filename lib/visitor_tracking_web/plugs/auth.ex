defmodule VisitorTrackingWeb.Plugs.Auth do
  @moduledoc """
  Authentication Plug module
  """

  import Plug.Conn
  import Phoenix.Controller

  alias VisitorTracking.Events

  def init(opts), do: opts

  def call(conn, _) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = user_id && VisitorTracking.Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _params) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Du musst dich anmelden, um diese Seite zu sehen.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def check_registered(conn, _params) do
    if conn.assigns.current_user do
      conn
      |> put_flash(:error, "You have already created a profile")
      |> redirect(to: "/phone_verification")
      |> halt()
    else
      conn
    end
  end

  def check_phone_verified(conn, _params) do
    if conn.assigns.current_user.phone_verified do
      conn
    else
      conn
      |> put_flash(:error, "Du musst zuerst deine E-Mail-Adresse bestätigen.")
      |> redirect(to: "/phone_verification")
      |> halt()
    end
  end

  def check_if_event_organiser(%{params: %{"event_id" => event_id}} = conn, _params) do
    case Events.get_event!(event_id, conn.assigns.current_user.id) do
      nil ->
        conn
        |> put_flash(:error, "You must be the organiser of an event to modify it")
        |> redirect(to: "/events/#{event_id}")
        |> halt()

      %Events.Event{} ->
        conn
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
