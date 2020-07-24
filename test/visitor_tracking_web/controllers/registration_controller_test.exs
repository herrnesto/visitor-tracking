defmodule VisitorTrackingWeb.RegistrationControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  test "GET /register shows a registration form", %{conn: conn} do
    conn = get(conn, "/register")

    assert html_response(conn, 200) =~ "Registrieren"
    assert html_response(conn, 200) =~ "Mobilnummer"
    assert html_response(conn, 200) =~ "Passwort"
  end

  describe "POST /users" do
    test "with valid data brings us to /phone_verification page", %{conn: conn} do
      conn =
        post(conn, "/users", %{
          user: %{
            phone: "+41000000000",
            password: "testpass",
            password_confirmation: "testpass"
          }
        })

      assert redirected_to(conn) == "/phone_verification"
    end
  end
end
