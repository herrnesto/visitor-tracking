defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user, phone_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  test "GET profile shows qrcode", %{conn: conn} do
    conn = get(conn, "/profile/qrcode")
    assert html_response(conn, 200)
  end

  test "GET /v/:token valid token verifies profile email", %{conn: conn} do
    %{token: token} = insert(:email_token, email: conn.assigns.current_user.email)
    conn = get(conn, "/v/#{token}")
    assert redirected_to(conn) == "/profile"
  end
end
