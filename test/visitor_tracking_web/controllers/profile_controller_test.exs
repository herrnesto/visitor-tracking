defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user, email_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  test "GET /profiles/new", %{conn: conn} do
    conn = get(conn, "/profiles/new")

    assert html_response(conn, 200) =~ "New Profile"
    assert html_response(conn, 200) =~ "Firstname"
    assert html_response(conn, 200) =~ "Lastname"
    assert html_response(conn, 200) =~ "Zip"
    assert html_response(conn, 200) =~ "City"
    assert html_response(conn, 200) =~ "Phone"
  end

  test "POST /profiles", %{conn: conn} do
    conn =
      post(conn, "/profiles", %{
        profile: %{
          firstname: "Test first name",
          lastname: "Test last name",
          zip: "15555",
          city: "Athens",
          phone: "+1000000000"
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