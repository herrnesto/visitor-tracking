defmodule VisitorTrackingWeb.ContactFormControllerTest do
  use VisitorTrackingWeb.ConnCase

  alias VisitorTracking.Form

  @create_attrs %{email: "mans@huster.com", message: "some message", name: "some name"}
  @invalid_attrs %{email: nil, message: nil, name: nil}

  def fixture(:contact_form) do
    {:ok, contact_form} = Form.create_contact_form(@create_attrs)
    contact_form
  end

  describe "create contact_form" do
    test "rednders ok when data is valid", %{conn: conn} do
      conn = post(conn, Routes.contact_form_path(conn, :create), contact_form: @create_attrs)

      assert conn.assigns.status =~ "ok"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.contact_form_path(conn, :create), contact_form: @invalid_attrs)
      assert conn.assigns.status =~ "error"
    end
  end

  defp create_contact_form(_) do
    contact_form = fixture(:contact_form)
    %{contact_form: contact_form}
  end
end
