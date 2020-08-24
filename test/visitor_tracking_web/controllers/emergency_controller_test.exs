defmodule VisitorTrackingWeb.EmergencyControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.{Accounts, Emergencies}
  alias VisitorTrackingWeb.EmergencyController

  @create_attrs %{recipient_email: "some recipient_email", recipient_name: "some recipient_name"}
  @update_attrs %{
    recipient_email: "some updated recipient_email",
    recipient_name: "some updated recipient_name"
  }
  @invalid_attrs %{recipient_email: nil, recipient_name: nil}

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)
    conn = assign(conn, :current_user, user)
    event = insert(:event, organiser: user)

    {:ok, %{conn: conn, event: event}}
  end

  def fixture(:emergency) do
    {:ok, emergency} = Emergencies.create_emergency(@create_attrs)
    emergency
  end

  describe "new emergency" do
    test "renders form", %{conn: conn, event: event} do
      conn = get(conn, Routes.emergency_path(conn, :new, event.id))
      assert html_response(conn, 200) =~ "alert notification is-danger"
      assert html_response(conn, 200) =~ "Neuer Ernstfall einleiten"
    end
  end

  describe "create emergency" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn, event: event} do
      conn = post(conn, Routes.emergency_path(conn, :create, event.id), emergency: @create_attrs)
      IO.inspect(redirected_params(conn))
      id = event.id
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event.id)

      conn = get(conn, Routes.event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "alert notification is-info"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{id: event_id} = insert(:event)

      conn = post(conn, Routes.emergency_path(conn, :create, event_id), emergency: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neuer Ernstfall einleiten"
    end
  end

  defp create_emergency(_) do
    emergency = fixture(:emergency)
    %{emergency: emergency}
  end
end
