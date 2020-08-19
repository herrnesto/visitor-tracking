defmodule VisitorTrackingWeb.EmergencyControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.Emergencies

  @create_attrs %{recipient_email: "some recipient_email", recipient_name: "some recipient_name"}
  @update_attrs %{
    recipient_email: "some updated recipient_email",
    recipient_name: "some updated recipient_name"
  }
  @invalid_attrs %{recipient_email: nil, recipient_name: nil}

  def fixture(:emergency) do
    {:ok, emergency} = Emergencies.create_emergency(@create_attrs)
    emergency
  end

  describe "index" do
    test "lists all emergencies", %{conn: conn} do
      conn = get(conn, Routes.emergency_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Emergencies"
    end
  end

  describe "new emergency" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.emergency_path(conn, :new))
      assert html_response(conn, 200) =~ "New Emergency"
    end
  end

  describe "create emergency" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.emergency_path(conn, :create), emergency: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.emergency_path(conn, :show, id)

      conn = get(conn, Routes.emergency_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Emergency"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.emergency_path(conn, :create), emergency: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Emergency"
    end
  end

  describe "edit emergency" do
    setup [:create_emergency]

    test "renders form for editing chosen emergency", %{conn: conn, emergency: emergency} do
      conn = get(conn, Routes.emergency_path(conn, :edit, emergency))
      assert html_response(conn, 200) =~ "Edit Emergency"
    end
  end

  describe "update emergency" do
    setup [:create_emergency]

    test "redirects when data is valid", %{conn: conn, emergency: emergency} do
      conn = put(conn, Routes.emergency_path(conn, :update, emergency), emergency: @update_attrs)
      assert redirected_to(conn) == Routes.emergency_path(conn, :show, emergency)

      conn = get(conn, Routes.emergency_path(conn, :show, emergency))
      assert html_response(conn, 200) =~ "some updated recipient_email"
    end

    test "renders errors when data is invalid", %{conn: conn, emergency: emergency} do
      conn = put(conn, Routes.emergency_path(conn, :update, emergency), emergency: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Emergency"
    end
  end

  describe "delete emergency" do
    setup [:create_emergency]

    test "deletes chosen emergency", %{conn: conn, emergency: emergency} do
      conn = delete(conn, Routes.emergency_path(conn, :delete, emergency))
      assert redirected_to(conn) == Routes.emergency_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.emergency_path(conn, :show, emergency))
      end
    end
  end

  defp create_emergency(_) do
    emergency = fixture(:emergency)
    %{emergency: emergency}
  end
end
