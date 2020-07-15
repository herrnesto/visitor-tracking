defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  alias VisitorTracking.Verification

  setup %{conn: conn} do
    user = insert(:user, email_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  test "GET /profiles/new", %{conn: conn} do
    conn = conn
    |> fetch_session()
    |> get("/profiles/new")

    assert html_response(conn, 200) =~ "New Profile"
    assert html_response(conn, 200) =~ "Firstname"
    assert html_response(conn, 200) =~ "Lastname"
    assert html_response(conn, 200) =~ "Zip"
    assert html_response(conn, 200) =~ "City"
    assert html_response(conn, 200) =~ "Phone"
  end

  test "POST /profiles", %{conn: conn} do
    user = insert(:user, email_verified: true)

    conn =
    conn
    |> put_session(:user_id, user.id)
    |> post("/profiles", %{ 
        firstname: "Test first name",
        lastname: "Test last name",
        zip: "15555",
        city: "Athens",
        phone: "+1000000000"
      })

    assert redirected_to(conn) == "/profiles/phone_verification"
  end
end
