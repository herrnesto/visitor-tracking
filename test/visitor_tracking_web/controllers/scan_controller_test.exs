defmodule VisitorTrackingWeb.ScanControllerTest do
  use VisitorTrackingWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = conn |> Plug.Test.init_test_session(user_id: user.id)
    event = insert(:event)
    insert(:scanner, event_id: event.id, user_id: user.id)

    {:ok, %{conn: conn, event: event, user: user}}
  end

  describe "GET /events/:id/scan" do
    test "redirects to /events/:id if user is not a scanner", %{conn: conn, event: event} do
      conn = get(conn, "/events/#{event.id}/scan")
      assert redirected_to(conn) =~ "/events/#{event.id}"
    end

    test "renders scan page if user is a scanner", %{conn: conn, user: user} do
      event = insert(:event, organiser: user, status: "open")
      insert(:scanner, event_id: event.id, user_id: user.id)

      conn = get(conn, "/events/#{event.id}/scan")

      assert html_response(conn, 200) =~ "event_id"
      assert html_response(conn, 200) =~ "event-scanner"
    end

    test "redirects to /events/:id if event is not open", %{conn: conn, user: user} do
      event = insert(:event, organiser: user)
      insert(:scanner, event_id: event.id, user_id: user.id)

      conn = get(conn, "/events/#{event.id}/scan")

      assert redirected_to(conn) =~ "/events/#{event.id}"
    end
  end

  describe "POST /api" do
    test "event infos", %{conn: conn, user: user} do
      event = insert(:event, organiser: user)
      insert(:scanner, event_id: event.id, user_id: user.id)

      conn = post(conn, "/api/scan/event_infos", %{"event_id" => event.id})

      test_data = %{
        "event" => %{"id" => event.id, "name" => "Test Event", "venue" => "Test Venue"},
        "status" => "ok",
        "visitors" => 0
      }

      assert json_response(conn, 200) == test_data
    end
  end

  describe "POST /api/scan/assign_visitor" do
    test "assign a visitor without beeing scanner", %{event: event} do
      user = insert(:user, email_verified: true, phone_verified: true)
      conn = build_conn() |> Plug.Test.init_test_session(user_id: user.id)

      %{uuid: uuid} = insert(:user, email_verified: true, phone_verified: true)

      conn = post(conn, "/api/scan/assign_visitor", %{"event_id" => event.id, "uuid" => uuid})
      assert redirected_to(conn) =~ "/events"
    end

    test "assign a visitor", %{conn: conn, event: event} do
      %{uuid: uuid} = insert(:user, email_verified: true, phone_verified: true)

      conn = post(conn, "/api/scan/assign_visitor", %{"event_id" => event.id, "uuid" => uuid})

      assert %{"status" => "ok"} = json_response(conn, 200)
    end

    test "assign a visitor is no longer possible if event is not open", %{conn: conn} do
      %{uuid: uuid} = insert(:user, email_verified: true, phone_verified: true)
      event = insert(:event, status: "closed")

      conn = post(conn, "/api/scan/assign_visitor", %{"event_id" => event.id, "uuid" => uuid})
      assert redirected_to(conn) =~ "/events"
    end
  end

  describe "POST /api/scan/user" do
    test "returns user json if user exists", %{conn: conn} do
      %{uuid: uuid} = insert(:user)
      conn = post(conn, "/api/scan/user", %{"uuid" => uuid})

      assert %{
               "status" => "ok"
             } = json_response(conn, 200)
    end

    test "returns error json if user does not exist", %{conn: conn} do
      conn = post(conn, "/api/scan/user", %{"uuid" => "testuuid"})

      assert %{
               "status" => "error",
               "message" => "not_found"
             } == json_response(conn, 200)
    end
  end
end
