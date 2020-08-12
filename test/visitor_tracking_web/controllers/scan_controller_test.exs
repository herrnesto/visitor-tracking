defmodule VisitorTrackingWeb.ScanControllerTest do
  use VisitorTrackingWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = assign(conn, :current_user, user)
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
end
