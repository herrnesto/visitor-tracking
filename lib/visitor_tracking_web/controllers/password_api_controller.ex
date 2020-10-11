defmodule VisitorTrackingWeb.PasswordApiController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Twilio, Password}
  alias VisitorTrackingWeb.Plugs.Auth

  def reset_password(conn, %{"user" => user_params, "token" => token}) do
    case Password.change_user_password(token, user_params) do
      {:ok, _} ->
        render(conn, "response.json", status: "ok", reason: "password changed")

      {:error, _} ->
        render(conn, "response.json", status: "error", reason: "password not changed")
    end
  end
end
