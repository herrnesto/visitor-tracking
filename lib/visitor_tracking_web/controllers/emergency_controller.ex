defmodule VisitorTrackingWeb.EmergencyController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Email, Events, Emergencies, Emergencies.Emergency, Mailer}

  def index(conn, _params) do
    emergencies = Emergencies.list_emergencies()
    render(conn, "index.html", emergencies: emergencies)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Emergencies.change_emergency(%Emergency{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end

  def create(conn, %{"emergency" => emergency_params, "event_id" => event_id}) do
    emergency_params =
      emergency_params
      |> Map.put("initiator_id", get_session(conn, :user_id))
      |> Map.put("event_id", event_id)

    emergency_params
    |> Emergencies.create_emergency()
    |> case do
      {:ok, emergency} ->
        emergency_params
        |> add_event_data()
        |> add_visitors_data()
        |> IO.inspect()
        |> Email.emergency_email()
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "Ein Ernstfall wurde eingeleitet und die Daten wurden übermittelt.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          "Hast du alles korrekt ausgefüllt? Oder wurde vielleicht bereits ein Ernstfall eingeleitet?"
        )
        |> render("new.html", changeset: changeset, event_id: event_id)
    end
  end

  def show(conn, %{"id" => id}) do
    emergency = Emergencies.get_emergency!(id)
    render(conn, "show.html", emergency: emergency)
  end

  defp add_visitors_data(%{"event_id" => event_id} = params) do
    visitors =
      event_id
      |> Events.get_all_visitors_by_event()
      |> Enum.reduce([], fn x, acc ->
        map =
          x
          |> Map.from_struct()
          |> Map.put_new(:actions, Events.get_all_visitor_actions_by_event(event_id, x.id))

        acc ++ [map]
      end)

    Map.put(params, "visitors", visitors)
  end

  defp add_event_data(%{"event_id" => event_id} = params) do
    Map.put_new(params, "event", Events.get_event_with_preloads(event_id))
  end
end
