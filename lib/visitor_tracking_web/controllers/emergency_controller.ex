defmodule VisitorTrackingWeb.EmergencyController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Emergencies
  alias VisitorTracking.Emergencies.Emergency

  def index(conn, _params) do
    emergencies = Emergencies.list_emergencies()
    render(conn, "index.html", emergencies: emergencies)
  end

  def new(conn, _params) do
    changeset = Emergencies.change_emergency(%Emergency{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"emergency" => emergency_params}) do
    case Emergencies.create_emergency(emergency_params) do
      {:ok, emergency} ->
        conn
        |> put_flash(:info, "Emergency created successfully.")
        |> redirect(to: Routes.emergency_path(conn, :show, emergency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    emergency = Emergencies.get_emergency!(id)
    render(conn, "show.html", emergency: emergency)
  end

  def edit(conn, %{"id" => id}) do
    emergency = Emergencies.get_emergency!(id)
    changeset = Emergencies.change_emergency(emergency)
    render(conn, "edit.html", emergency: emergency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "emergency" => emergency_params}) do
    emergency = Emergencies.get_emergency!(id)

    case Emergencies.update_emergency(emergency, emergency_params) do
      {:ok, emergency} ->
        conn
        |> put_flash(:info, "Emergency updated successfully.")
        |> redirect(to: Routes.emergency_path(conn, :show, emergency))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", emergency: emergency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    emergency = Emergencies.get_emergency!(id)
    {:ok, _emergency} = Emergencies.delete_emergency(emergency)

    conn
    |> put_flash(:info, "Emergency deleted successfully.")
    |> redirect(to: Routes.emergency_path(conn, :index))
  end
end
