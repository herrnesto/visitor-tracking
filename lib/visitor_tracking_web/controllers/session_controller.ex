defmodule VisitorTrackingWeb.SessionController do
  use VisitorTrackingWeb, :controller

  use PhoenixMetaTags.TagController

  alias VisitorTracking.Accounts
  alias VisitorTrackingWeb.Plugs.Auth

  def new(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Anmelden | Vesita",
      description: "Melde dich an und erhalte Zugang zu deinen Kontaktdaten.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("new.html")
  end

  def create(conn, %{"phone" => phone, "session" => %{"password" => password}}) do
    case Accounts.authenticate_by_phone_and_password(phone, password) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> redirect(to: "/profile")

      {:error, _} ->
        conn
        |> put_flash(:error, "Die Mobilnummer und/oder das Passwort ist falsch.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: "/login")
  end
end
