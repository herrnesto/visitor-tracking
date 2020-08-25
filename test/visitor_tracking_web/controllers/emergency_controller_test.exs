defmodule VisitorTrackingWeb.EmergencyControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.Emergencies

  @create_attrs %{
    "emergency" => %{
      "recipient_email" => "recipient@example.com",
      "recipient_name" => "some recipient_name"
    }
  }
  @invalid_attrs %{
    "emergency" => %{
      "recipient_email" => nil,
      "recipient_name" => nil
    }
  }

  setup %{conn: conn} do
    user = insert(:user, email_verified: true, phone_verified: true)

    conn =
      conn
      |> assign(:current_user, user)
      |> Plug.Test.init_test_session(user_id: user.id)

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
    test "redirects to show when data is valid", %{conn: conn, event: %{id: event_id}} do
      conn = post(conn, Routes.emergency_path(conn, :create, event_id), @create_attrs)
      %{id: id} = redirected_params(conn)
      assert "#{event_id}" == id
      assert redirected_to(conn) == Routes.event_path(conn, :show, event_id)

      conn = get(conn, Routes.event_path(conn, :show, event_id))
      assert html_response(conn, 200) =~ "alert notification is-info"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{id: event_id} = insert(:event)

      conn = post(conn, Routes.emergency_path(conn, :create, event_id), emergency: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neuer Ernstfall einleiten"
    end
  end
end
