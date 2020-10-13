defmodule VisitorTrackingWeb.RegistrationApiController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Email, Mailer, Twilio, Verification}
  alias VisitorTrackingWeb.Plugs.Auth

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> render("response.json", status: "ok", params: user_params)

      {:error, _changeset} ->
        render(conn, "response.json", status: "error", params: user_params)
    end
  end

  def verify_phone(conn, %{"code" => code}) do
    user = Accounts.get_user(get_session(conn, :user_id))

    case Verification.verify_sms_code(code, user.phone) do
      {:error, reason} ->
        render(conn, "response.json", status: "error", reason: reason)

      {:ok, visitor_id} ->
        Accounts.verify_phone(visitor_id)

        Twilio.send_qr(%{
          uri: get_uri(Routes.qr_path(conn, :show, user.uuid)),
          target_number: user.phone
        })

        send_email_verifictation(user)

        render(conn, "response.json", status: "ok", reason: "phone verified")
    end
  end

  def send_email_verifictation(user) do
    {:ok, token} = Verification.create_link_token(user.id, user.email)

    user.email
    |> Email.verification_email(token)
    |> Mailer.deliver_later()
  end

  defp get_uri(path) do
    get_protocol() <> get_host() <> path
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
