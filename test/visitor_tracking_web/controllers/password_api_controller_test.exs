defmodule VisitorTrackingWeb.PasswordApiControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user, phone: "+41000000000")
    token = insert(:password_token, phone: user.phone)

    {:ok, %{conn: conn, user: user, token: token}}
  end

  describe "POST /api" do
    test "with valid data", %{conn: conn, token: token} do
      conn =
        post(conn, "/api/password/reset", %{
          token: token.token,
          user: %{
            password: "testpass",
            password_confirmation: "testpass"
          }
        })

      assert %{"status" => "ok"} = json_response(conn, 200)
    end

    test "with invalid data", %{conn: conn, token: token} do
      conn =
        post(conn, "/api/password/reset", %{
          token: token.token,
          user: %{
            password: "testpass",
            password_confirmation: "wrongpass"
          }
        })

      assert %{"status" => "error"} = json_response(conn, 200)
    end
  end
end
