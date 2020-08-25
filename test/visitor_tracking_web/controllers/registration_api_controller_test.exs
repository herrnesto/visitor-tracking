defmodule VisitorTrackingWeb.RegistrationApiControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  describe "POST /api" do
    test "with valid data", %{conn: conn} do
      conn =
        post(conn, "/api/registration/user", %{
          user: %{
            phone: "+41000000000",
            password: "testpass",
            password_confirmation: "testpass",
            firstname: "Test",
            lastname: "User",
            city: "Whatever",
            zip: "1234",
            email: "test@example.com"
          }
        })

      assert %{"status" => "ok"} = json_response(conn, 200)
    end

    test "with invalid data", %{conn: conn} do
      conn =
        post(conn, "/api/registration/user", %{
          user: %{
            phone: "+41000000000",
            password: "testpass",
            password_confirmation: "testpass",
            firstname: "Test",
            lastname: "User",
            city: "Whatever",
            zip: "ad",
            email: "asdxample.com"
          }
        })

      assert %{"status" => "error"} = json_response(conn, 200)
    end
  end
end
