defmodule VisitorTrackingWeb.EmergencyController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Emergencies
  alias VisitorTracking.Emergencies.Emergency

  def index(conn, _params) do
    emergencies = Emergencies.list_emergencies()
    render(conn, "index.html", emergencies: emergencies)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Emergencies.change_emergency(%Emergency{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end

  def create(conn, %{"emergency" => emergency_params, "event_id" => event_id}) do
    emergency_params
    |> Map.put("initiator_id", get_session(conn, :user_id))
    |> Map.put("event_id", event_id)
    |> Emergencies.create_emergency()
    |> case do
      {:ok, emergency} ->
        conn
        |> put_flash(:info, "Emergency created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, event_id: event_id)
    end
  end

  def show(conn, %{"id" => id}) do
    emergency = Emergencies.get_emergency!(id)
    render(conn, "show.html", emergency: emergency)
  end
end
