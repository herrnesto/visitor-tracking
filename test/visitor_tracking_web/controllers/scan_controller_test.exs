defmodule VisitorTrackingWeb.ScanControllerTest do
  use VisitorTrackingWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = conn |> Plug.Test.init_test_session(user_id: user.id)
    event = insert(:event, organiser: user)

    {:ok, %{conn: conn, event: event}}
  end

  describe "GET /events/:id/scan" do
    test "redirects to /events/:id if user is not a scanner", %{conn: conn, event: event} do
      conn = get(conn, "/events/#{event.id}/scan")
      assert redirected_to(conn) =~ "/events/#{event.id}"
    end

    test "renders scan page if user is a scanner" do
      user = insert(:user, email_verified: true, phone_verified: true)
      event = insert(:event, organiser: user)
      insert(:scanner, event_id: event.id, user_id: user.id)

      conn =
        build_conn()
        |> assign(:current_user, user)
        |> get("/events/#{event.id}/scan")

      assert html_response(conn, 200) =~ "event_id"
      assert html_response(conn, 200) =~ "event-scanner"
    end
  end

  describe "POST /api" do
    test "event infos", %{conn: conn, event: event} do
      conn = post(conn, "/api/scan/event_infos", %{"id" => event.id})

      test_data = %{
        "event" => %{"id" => event.id, "name" => "Test Event", "venue" => "Test Venue"},
        "status" => "ok",
        "visitors" => 0
      }

      assert json_response(conn, 200) == test_data
    end
  end
end
