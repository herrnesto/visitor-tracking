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

  describe "GET profile" do
    setup %{conn: conn} do
      user = insert(:user, email_verified: true, phone_verified: true)
      conn = assign(conn, :current_user, user)

      {:ok, %{conn: conn}}
    end

    test "show qrcode", %{conn: conn} do
      conn = get(conn, "/profile/qrcode")
      assert html_response(conn, 200)
    end
  end

  describe "GET /v/:token" do
    test "verifies email if token is correct" do
      user = insert(:user)
      {:ok, token} = VisitorTracking.Verification.create_link_token(user.id, user.email)

      conn = get(build_conn(), "/v/#{token}")

      assert redirected_to(conn) == "/profile"
    end

    test "returns an error if token is wrong" do
      conn = get(build_conn(), "/v/wrong_token")

      assert redirected_to(conn) == "/expecting_verification"
    end
  end
end
