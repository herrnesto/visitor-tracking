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
      user = insert(:user, email_verified: true)
      profile = insert(:profile, user_id: user.id, phone_verified: true)
      conn = assign(conn, :current_user, %{user | profile: profile})

      {:ok, %{conn: conn}}
    end

    test "show qrcode", %{conn: conn} do
      conn = get(conn, "/profile/qrcode")
      assert html_response(conn, 200)
    end
  end
end
