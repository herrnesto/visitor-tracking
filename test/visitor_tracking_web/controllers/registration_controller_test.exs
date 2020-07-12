defmodule VisitorTrackingWeb.RegistrationControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  test "GET /register shows a registration form", %{conn: conn} do
    conn = get(conn, "/register")

    assert html_response(conn, 200) =~ "Register"
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
    assert html_response(conn, 200) =~ "Password confirmation"
  end

  describe "POST /users" do
    test "with valid data brings us to /verify_email page", %{conn: conn} do
      conn =
        post(conn, "/users", %{
          email: "test@example.com",
          password: "testpass",
          password_confirmation: "testpass"
        })

      assert redirected_to(conn) == "/verify_email"
    end
  end
end
