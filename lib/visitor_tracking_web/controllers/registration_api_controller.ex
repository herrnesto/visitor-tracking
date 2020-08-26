defmodule VisitorTrackingWeb.RegistrationApiController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.Accounts
  alias VisitorTrackingWeb.Plugs.Auth

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> render("response.json", status: "ok", params: user_params)

      {:error, changeset} ->
        render(conn, "response.json", status: "error", params: user_params)
    end
  end
end
