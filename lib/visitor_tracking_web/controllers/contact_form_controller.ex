defmodule VisitorTrackingWeb.ContactFormController do
  use VisitorTrackingWeb, :controller

  use PhoenixMetaTags.TagController

  alias VisitorTracking.{Email, Form, Form.ContactForm, Mailer}

  def new(conn, _params) do
    changeset = Form.change_contact_form(%ContactForm{})

    conn
    |> put_meta_tags(%{
      title: "Schreibe uns eine Nachricht! | Vesita",
      description:
        "Melde dich bei uns wenn du eine Frage hast oder hinterlasse uns einen Gruss :-)",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("new.html", changeset: changeset, api_url: get_api_url())
  end

  def create(conn, %{"contact_form" => contact_form_params}) do
    case Form.create_contact_form(contact_form_params) do
      {:ok, _contact_form} ->
        contact_form_params
        |> Email.contact_form_email()
        |> Mailer.deliver_later()

        render(conn, "response.json", status: "ok", params: contact_form_params)

      {:error, %Ecto.Changeset{} = _changeset} ->
        render(conn, "response.json", status: "error", params: contact_form_params)
    end
  end

  def show(conn, %{"id" => id}) do
    contact_form = Form.get_contact_form!(id)
    render(conn, "show.html", contact_form: contact_form)
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
