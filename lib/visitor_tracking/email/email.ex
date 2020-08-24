defmodule VisitorTracking.Email do
  @moduledoc """
  Contains functions for composing emails.
  """
  use Bamboo.Phoenix, view: VisitorTrackingWeb.EmailView

  def verification_email(email, token) do
    base_email()
    |> to(email)
    |> subject("Bestätige deine E-Mail-Adresse")
    |> assign(:args, %{email: email, url: get_verification_url(token)})
    |> render(:verification)
  end

  def qrcode_email(user, qrcode) do
    base_email()
    |> to(user.email)
    |> subject("Dein QR-Code")
    |> assign(:user, user)
    |> assign(:qrcode, qrcode)
    |> render(:qrcode)
  end

  def contact_form_email(%{"name" => name, "email" => email, "message" => message}) do
    base_email()
    |> to("hello@vesita.ch")
    |> subject("Nachricht von: " <> name)
    |> assign(:name, name)
    |> assign(:email, email)
    |> assign(:message, message)
    |> render(:contact_form)
  end

  def emergency_email(%{
        "visitors" => visitors,
        "recipient_email" => recipient_email,
        "recipient_name" => recipient_name
      }) do
    base_email()
    |> to(recipient_email)
    |> subject("Contact Tracing Daten")
    |> assign(:recipient_name, recipient_name)
    |> assign(:visitors, visitors)
    |> render(:emergency)
  end

  defp base_email do
    new_email()
    |> from("Vesita<hello@vesita.ch>")
    |> put_header("Reply-To", "hello@vesita.ch")
    # This will use the "email.html.eex" file as a layout when rendering html emails.
    # Plain text emails will not use a layout unless you use `put_text_layout`
    |> put_html_layout({VisitorTrackingWeb.LayoutView, "email.html"})
  end

  def get_verification_url(token) do
    get_protocol() <> get_host() <> "/v/#{token}"
  end

  def get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  def get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
