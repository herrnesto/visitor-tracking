defmodule VisitorTracking.Email do
  use Bamboo.Phoenix, view: VisitorTrackingWeb.EmailView

  def verification_email({_name, email} = person) do
    base_email()
    |> to(person)
    |> subject("Bestätige deine Email")
    |> assign(:args, %{email: email, token: "1343432"})
    |> render(:verification)
  end

  defp base_email do
    new_email
    |> from("Rob Ot<robot@changelog.com>")
    |> put_header("Reply-To", "editors@changelog.com")
    # This will use the "email.html.eex" file as a layout when rendering html emails.
    # Plain text emails will not use a layout unless you use `put_text_layout`
    |> put_html_layout({VisitorTrackingWeb.LayoutView, "email.html"})
  end
end
