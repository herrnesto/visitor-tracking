defmodule VisitorTrackingWeb.EventControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.Events

  @create_attrs %{
    closed: true,
    date_end: "2010-04-17T14:00:00Z",
    date_start: "2010-04-17T14:00:00Z",
    description: "some description",
    name: "some name",
    status: "some status",
    venue: "some venue"
  }
  @update_attrs %{
    closed: false,
    date_end: "2011-05-18T15:01:01Z",
    date_start: "2011-05-18T15:01:01Z",
    description: "some updated description",
    name: "some updated name",
    status: "some updated status",
    venue: "some updated venue"
  }
  @invalid_attrs %{
    closed: nil,
    date_end: nil,
    date_start: nil,
    description: nil,
    name: nil,
    status: nil,
    venue: nil
  }

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = assign(conn, :current_user, user)

    {:ok, %{conn: conn}}
  end

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert html_response(conn, 200) =~ "Deine Veranstaltungen"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "Neue Veranstaltung"
    end
  end

  describe "create event" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.event_path(conn, :show, id)

      conn = get(conn, Routes.event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Infos zur Veranstaltung"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neue Veranstaltung"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Veranstaltung bearbeiten"
    end
  end

  describe "update event" do
    setup [:create_event]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event)

      conn = get(conn, Routes.event_path(conn, :show, event))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Veranstaltung bearbeiten"
    end
  end

  describe "delete event" do
    setup [:create_event]

    @tag :skip
    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    %{event: event}
  end
end
