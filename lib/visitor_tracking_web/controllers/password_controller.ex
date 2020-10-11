defmodule VisitorTrackingWeb.PasswordController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Twilio, Password}
  alias VisitorTrackingWeb.Plugs.Auth

  def reset_password_request_form(conn, _) do
    conn
    |> render("reset_password.html")
  end

  def reset_password_request(conn, %{"phone" => phone}) do
    with {:ok, token} <- Password.create_token(phone),
         url <- Routes.password_path(conn, :reset_password, token),
         {:ok, _} <- Twilio.send_password_reset(%{url: url, target_number: phone}) do
      render(conn, "reset_password_request.html")
    else
      {:error, :wait_before_recreate} ->
        conn
        |> put_flash(
          :error,
          "Du kannst nur alle 15 Minuten einen Link anfordern. Bitte lade die Seite in wenigen Augenblicken neu."
        )
        |> render("reset_password.html")

      {:error, status} ->
        conn
        |> put_flash(:error, "SMS Gateway Fehler (#{status})")
        |> render("reset_password.html")

      error ->
        conn
        |> put_flash(:error, error)
        |> render("reset_password.html")
    end
  end

  def reset_password(conn, %{"token" => token}) do
    case Password.verify_token(token) do
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> render("reset_password.html")

      {:ok, _} ->
        conn
        |> put_flash(:info, "Gültiger Token!")
        |> render("reset_password_form.html", api_url: get_api_url(), token: token)
    end

    conn
  end

  defp get_api_url do
    get_protocol() <> get_host()
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
