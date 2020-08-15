defmodule VisitorTrackingWeb.ScanController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Events}

  plug :check_if_scanner when action in [:show, :assign_visitor, :event_infos]

  def show(conn, %{"event_id" => id}) do
    case Events.get_event(id) do
      event = %{status: "open"} ->
        render(conn, "index.html", %{event: event, api_url: get_api_url()})

      %{status: _} ->
        conn
        |> put_flash(:error, "The event is not open, you are not able to scan")
        |> redirect(to: "/events/#{id}")
    end
  end

  def user(conn, %{"uuid" => uuid}) do
    case Accounts.get_user_by(uuid: uuid) do
      nil -> render(conn, "error.json", error: "not_found")
      user -> render(conn, "user.json", user: user)
    end
  end

  def assign_visitor(conn, %{"event_id" => event_id, "uuid" => uuid}) do
    with user <- Accounts.get_user_by(uuid: uuid),
         event <- Events.get_event(event_id) do
      Events.assign_visitor(event, user)

      render(conn, "assiged_visitor.json", status: "ok", event: event, user: user)
    end
  end

  def event_infos(conn, %{"event_id" => event_id}) do
    event = Events.get_event(event_id)

    render(conn, "event_infos.json", %{
      status: "ok",
      event: event,
      visitors: Events.count_visitors(event.id)
    })
  end

  defp get_api_url do
    get_protocol() <> get_host() <> "/api"
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end

  defp check_if_scanner(conn, _params) do
    case is_scanner?(conn) do
      true ->
        conn

      false ->
        conn
        |> redirect(to: "/events")
        |> halt()
    end
  end

  defp is_scanner?(%{params: %{"event_id" => event_id}} = conn) do
    with %{scanners: scanners} <- Events.get_event_with_preloads(event_id),
         user_id <- get_session(conn, :user_id),
         true <- user_in_scanners?(scanners, user_id) do
      true
    else
      _ ->
        false
    end
  end

  defp is_scanner?(_), do: false

  defp user_in_scanners?(scanners, user_id) do
    Enum.any?(scanners, fn %{id: id} -> id == user_id end)
  end
end
