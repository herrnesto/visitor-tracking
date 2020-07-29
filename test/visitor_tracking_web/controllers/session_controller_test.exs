defmodule VisitorTrackingWeb.SessionControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(VisitorTrackingWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "GET /login", %{conn: conn} do
    conn = get(conn, "/login")
    assert html_response(conn, 200) =~ "Login"
    assert html_response(conn, 200) =~ "Mobilnummer"
    assert html_response(conn, 200) =~ "Passwort"
  end

  describe "POST /sessions" do
    test "with empty form data renders login", %{conn: conn} do
      conn = post(conn, "/sessions", %{"session" => %{"phone" => "", "password" => ""}})

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data renders error if user does not exist", %{conn: conn} do
      conn =
        post(conn, "/sessions", %{
          "session" => %{"phone" => "+41000000000", "password" => "testpass"}
        })

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data renders error if user exists but password is wrong", %{conn: conn} do
      insert(:user, phone: "+41000000000")

      conn =
        post(conn, "/sessions", %{
          "session" => %{"phone" => "+41000000000", "password" => "nottestpass"}
        })

      assert get_session(conn, :user_id) == nil
      assert html_response(conn, 200) =~ "Login"
    end

    test "with actual form data redirects if user exists and password correct", %{conn: conn} do
      user = insert(:user, phone: "+41000000000", phone_verified: true)

      conn =
        post(conn, "/sessions", %{
          "session" => %{"phone" => "+41000000000", "password" => "testpass"}
        })

      assert conn.assigns.current_user == user
      assert get_session(conn, :user_id) == user.id
      assert redirected_to(conn) == "/profile"
    end
  end
end
