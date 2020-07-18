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

  defp base_email do
    new_email()
    |> from("Vesita<hello@vesita.ch>")
    |> put_header("Reply-To", "hello@vesita.ch")
    # This will use the "email.html.eex" file as a layout when rendering html emails.
    # Plain text emails will not use a layout unless you use `put_text_layout`
    |> put_html_layout({VisitorTrackingWeb.LayoutView, "email.html"})
  end

  def get_verification_url(token) do
    "https://" <> Application.get_env(:visitor_tracking, :host) <> "/v/#{token}"
  end
end
