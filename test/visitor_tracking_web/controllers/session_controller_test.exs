defmodule VisitorTrackingWeb.SessionControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, "/sessions/new")
    assert html_response(conn, 200) =~ "Login"
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
  end

  describe "POST /sessions" do
    test "with empty form data renders login", %{conn: conn} do
      conn = post(conn, "/sessions", %{"session" => %{"email" => "", "password" => ""}})

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data renders error if user does not exist", %{conn: conn} do
      conn =
        post(conn, "/sessions", %{
          "session" => %{"email" => "test@test.com", "password" => "testpass"}
        })

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data renders error if user exists but password is wrong", %{conn: conn} do
      user = insert(:user, email: "test@test.com")

      conn =
        post(conn, "/sessions", %{
          "session" => %{"email" => "test@test.com", "password" => "nottestpass"}
        })

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data redirects if user exists and password correct", %{conn: conn} do
      user = insert(:user, email: "test@test.com")

      conn =
        post(conn, "/sessions", %{
          "session" => %{"email" => "test@test.com", "password" => "testpass"}
        })

      assert conn.assigns.current_user == user
      assert get_session(conn, :user_id) == user.id
      assert redirected_to(conn) == "/"
    end
  end
end
