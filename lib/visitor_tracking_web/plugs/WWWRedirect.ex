defmodule App.Plugs.WWWRedirect do
  @moduledoc """
  Redirection Plug module
  """

  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    conn
    |> redirect_https()
    |> redirect_www()
  end

  def redirect_https(conn) do
    case conn.scheme do
      "http" ->
        conn
        |> Phoenix.Controller.redirect(external: "https://#{conn.host}")
        |> halt()

      _ ->
        conn
    end
  end

  def redirect_www(conn) do
    if bare_domain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: www_url(conn))
      |> halt
    else
      conn
    end
  end

  defp www_url(conn) do
    "#{conn.scheme}://www.#{conn.host}"
  end

  defp bare_domain?(host) do
    !Regex.match?(
      ~r/^([A-Za-z0-9](?:(?:[-A-Za-z0-9]){0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:(?:[-A-Za-z0-9]){0,61}[A-Za-z0-9])?){2,})$/i,
      host
    )
  end
end
