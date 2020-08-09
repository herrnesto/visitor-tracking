defmodule VisitorTrackingWeb.ScannerControllerTest do
  use VisitorTrackingWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = assign(conn, :current_user, user)
    event = insert(:event, organiser: user)

    {:ok, %{conn: conn, event: event}}
  end

  describe "GET /events/:id/scanners" do
    test "renders an error if no scanners have been assigned", %{conn: conn, event: event} do
      conn = get(conn, "/events/#{event.id}/scanners")
      assert html_response(conn, 200) =~ "No scanner users have been assigned"
    end

    test "redirects if the current user is not the event organiser", %{conn: conn} do
      event = insert(:event)
      conn = get(conn, "/events/#{event.id}/scanners")
      assert redirected_to(conn) =~ "/events/#{event.id}"
    end

    test "renders a table with one scanner", %{conn: conn, event: event} do
      phone = "+41000000000"

      user = insert(:user, phone: phone, email_verified: true, phone_verified: true)
      insert(:scanner, event: event, user: user)

      conn = get(conn, "/events/#{event.id}/scanners")

      assert html_response(conn, 200) =~ phone
    end
  end

  describe "GET /events/:id/scanners/new" do
    test "shows a form to add a new user by phone", %{conn: conn, event: event} do
      conn = get(conn, "/events/#{event.id}/scanners/new")
      assert html_response(conn, 200) =~ "Phone"
    end

    test "redirects if the current user is not the event organiser", %{conn: conn} do
      event = insert(:event)
      conn = get(conn, "/events/#{event.id}/scanners/new")
      assert redirected_to(conn) =~ "/events/#{event.id}"
    end
  end

  describe "POST /events/:id/scanners" do
    test "rerenders form if the phone does not point to existing user", %{
      conn: conn,
      event: event
    } do
      conn = post(conn, "/events/#{event.id}/scanners", %{"phone" => "+41000000000"})

      assert html_response(conn, 200) =~ "Phone"
      assert html_response(conn, 200) =~ "User does not exist"
    end

    test "redirects to scanners/index if user exists", %{conn: conn, event: event} do
      phone = "+41000000000"
      insert(:user, phone: phone, phone_verified: true, email_verified: true)
      conn = post(conn, "/events/#{event.id}/scanners", %{"phone" => phone})
      assert redirected_to(conn) =~ "/events/#{event.id}/scanners"
    end

    test "redirects if the current user is not the event organiser", %{conn: conn} do
      phone = "+41000000000"
      insert(:user, phone: phone, phone_verified: true, email_verified: true)
      event = insert(:event)
      conn = post(conn, "/events/#{event.id}/scanners", %{"phone" => phone})
      assert redirected_to(conn) =~ "/events/#{event.id}"
    end
  end
end
