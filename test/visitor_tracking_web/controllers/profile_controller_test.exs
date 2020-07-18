defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user, email_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  test "GET /profiles/new", %{conn: conn} do
    conn = get(conn, "/profiles/new")

    assert html_response(conn, 200) =~ "Vorname"
    assert html_response(conn, 200) =~ "Nachname"
    assert html_response(conn, 200) =~ "Postleitzahl"
    assert html_response(conn, 200) =~ "Stadt"
    assert html_response(conn, 200) =~ "Mobilnummer"
  end

  @tag :skip
  test "POST /profiles", %{conn: conn} do
    conn =
      post(conn, "/profiles", %{
        profile: %{
          firstname: "Test first name",
          lastname: "Test last name",
          zip: "15555",
          city: "Athens",
          phone: "+41790000000"
        }
      })

    assert redirected_to(conn) == "/profiles/phone_verification"
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
