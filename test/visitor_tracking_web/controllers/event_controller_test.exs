defmodule VisitorTrackingWeb.EventControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.Events

  @create_attrs %{
    closed: true,
    date_start: "2010-04-17T14:00:00Z",
    name: "some name",
    status: "some status",
    venue: "some venue",
    visitor_limit: 100
  }

  @update_attrs %{
    closed: false,
    date_start: "2011-05-18T15:01:01Z",
    name: "some updated name",
    status: "some updated status",
    venue: "some updated venue",
    visitor_limit: 120
  }

  @invalid_attrs %{
    closed: nil,
    date_start: nil,
    name: nil,
    status: nil,
    venue: nil,
    visitor_limit: 0
  }

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = assign(conn, :current_user, user)
    event = insert(:event, organiser: user)

    {:ok, %{conn: conn, event: event}}
  end

  describe "GET /events/id" do
    test "shows an event", %{conn: conn, event: event} do
      conn = get(conn, "/events/#{event.id}")
      assert html_response(conn, 200) =~ "Infos zur Veranstaltung"
    end
  end

  describe "GET /events" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert html_response(conn, 200) =~ "Deine Veranstaltungen"
    end
  end

  describe "GET /events/new" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "Neue Veranstaltung"
    end
  end

  describe "POST /events" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)

      assert "/events/" <> id = redirected_to(conn)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neue Veranstaltung"
    end
  end

  describe "GET /events/:id/edit" do
    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Veranstaltung bearbeiten"
    end
  end

  describe "PUT /events/:id" do
    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event)
      assert %{venue: "some updated venue"} = Events.get_event(event.id)
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Veranstaltung bearbeiten"
    end
  end

  describe "DELETE /events/:id" do
    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :index)
      assert nil == Events.get_event(event.id)
    end
  end
end
