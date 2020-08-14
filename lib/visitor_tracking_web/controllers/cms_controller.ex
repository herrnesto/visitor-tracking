defmodule VisitorTrackingWeb.CmsController do
  use VisitorTrackingWeb, :controller

  use PhoenixMetaTags.TagController

  def homepage(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Effizientes Besucher-Tracking an deiner Veranstaltung | Vesita",
      description:
        "Vesita, die einfache und kostengünstige Lösung zur Erfassung der Besucherdaten an deiner Veranstaltung.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("homepage.html", [])
  end

  def privacy(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Datenschutz | Vesita",
      description: "Datenschutz steht bei uns an oberster Stelle.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("privacy.html", [])
  end

  def howto(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "So einfach funktioniert Vesita | Vesita",
      description: "Einfach zu bedienen für Veranstalter und Besucher.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("howto.html", [])
  end

  def prices(conn, _) do
    conn
    |> put_meta_tags(%{
      title: "Viele Vorteile für wenig Geld | Vesita",
      description:
        "Jeder Veranstaler soll sich Vesita leisten können. Keine Lizenz- oder Grundgebühren.",
      url: "https://www.vesita.ch",
      image:
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png",
      "og:image":
        "https://" <>
          Application.get_env(:visitor_tracking, :host) <> "/images/vesita-logo-full-klein.png"
    })
    |> render("prices.html", [])
  end
end
