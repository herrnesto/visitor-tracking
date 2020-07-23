defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user, phone_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  test "GET /profiles/new", %{conn: conn} do
    conn = get(conn, "/profiles/new")

    assert html_response(conn, 200) =~ "Vorname"
    assert html_response(conn, 200) =~ "Nachname"
    assert html_response(conn, 200) =~ "Postleitzahl"
    assert html_response(conn, 200) =~ "Stadt"
    assert html_response(conn, 200) =~ "E-Mail"
  end

  test "POST /profiles", %{conn: conn} do
    conn =
      post(conn, "/profiles", %{
        profile: %{
          firstname: "Test first name",
          lastname: "Test last name",
          zip: "1555",
          city: "Athens",
          email: "test@example.com"
        }
      })

    assert redirected_to(conn) == "/expecting_verification"
  end

  describe "GET profile" do
    setup %{conn: conn} do
      user = insert(:user, phone_verified: true)
      profile = insert(:profile, user: user, email_verified: true)
      conn = assign(conn, :current_user, %{user | profile: profile})

      {:ok, %{conn: conn}}
    end

    test "show qrcode", %{conn: conn} do
      conn = get(conn, "/profile/qrcode")
      assert html_response(conn, 200)
    end
  end
end
