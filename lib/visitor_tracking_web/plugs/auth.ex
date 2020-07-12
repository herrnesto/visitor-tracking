defmodule VisitorTrackingWeb.Plugs.Auth do
  @moduledoc """
  Authentication Plug module
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && VisitorTracking.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
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
