defmodule VisitorTrackingWeb.RegistrationControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true
  alias VisitorTracking.Verification

  test "GET /register shows a registration form", %{conn: conn} do
    conn = get(conn, "/register")

    assert html_response(conn, 200) =~ "Register"
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
    assert html_response(conn, 200) =~ "Password confirmation"
  end

  describe "POST /users" do
    test "with valid data brings us to /expecting_verification page", %{conn: conn} do
      conn =
        post(conn, "/users", %{
          email: "test@example.com",
          password: "testpass",
          password_confirmation: "testpass"
        })

      assert redirected_to(conn) == "/expecting_verification"
    end
  end

  describe "GET /v/:token" do
    test "valid token verifies user email", %{conn: conn} do
      conn =
        post(conn, "/users", %{
              email: "test@example.com",
              password: "testpass",
              password_confirmation: "testpass"
             })

      assert redirected_to(conn) == "/expecting_verification"

      %Verification.Token{token: token} = Verification.get_token_by_email("test@example.com")

      conn = get(conn, "/v/#{token}")

      assert redirected_to(conn) == "/profiles/new"
    end
  end
end
