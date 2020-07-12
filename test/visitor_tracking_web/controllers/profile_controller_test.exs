defmodule VisitorTrackingWeb.ProfileControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  test "GET /profiles/new", %{conn: conn} do
    conn = get(conn, "/profiles/new")

    assert html_response(conn, 200) =~ "New Profile"
    assert html_response(conn, 200) =~ "Firstname"
    assert html_response(conn, 200) =~ "Lastname"
    assert html_response(conn, 200) =~ "Zip"
    assert html_response(conn, 200) =~ "City"
    assert html_response(conn, 200) =~ "Phone"
  end
end
