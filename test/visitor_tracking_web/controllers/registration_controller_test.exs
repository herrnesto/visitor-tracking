defmodule VisitorTrackingWeb.RegistrationControllerTest do
  use VisitorTrackingWeb.ConnCase, async: true

  describe "GET /register" do
    test "when passed a valid phone shows a registration form", %{conn: conn} do
      conn = post(conn, "/register", %{"phone" => "+41000000000"})

      assert html_response(conn, 200) =~ "Registrieren"
      assert html_response(conn, 200) =~ "vue-registration-form"
    end

    test "when passed an existing phone redirects to /login", %{conn: conn} do
      insert(:user, phone: "+41000000000")

      conn = post(conn, "/register", %{"phone" => "+41000000000"})

      assert redirected_to(conn) =~ "/login"
    end
  end

  describe "POST /users" do
    test "with valid data brings us to /phone_verification page", %{conn: conn} do
      conn =
        post(conn, "/users", %{
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

      assert redirected_to(conn) == "/phone_verification"
    end
  end

  describe "POST /phone_confirmation" do
    test "when passed a valid phone shows a registration form", %{conn: conn} do
      conn = post(conn, "/phone_confirmation", %{"phone" => "+41000000000"})

      assert html_response(conn, 200) =~ "Ändern"
      assert html_response(conn, 200) =~ "Bestätigen"
    end
  end

  describe "GET /phone_validation" do
    test "Show input field with button", %{conn: conn} do
      html_floki = get(conn, "/phone_validation") |> html_response(200) |> Floki.parse_document!()
      assert [{"div", [{"id", "phone-input"}], []}] = Floki.find(html_floki, "div#phone-input")
    end
  end
end
