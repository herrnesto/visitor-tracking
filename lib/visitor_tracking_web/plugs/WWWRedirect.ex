defmodule App.Plugs.WWWRedirect do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if bare_domain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: www_url(conn))
      |> halt
    else
      conn # Since all plugs need to return a connection
    end
  end

  # Returns URL with www prepended for the given connection. Note this also
  # applies to hosts that already contain "www"
  defp www_url(conn) do
    "#{conn.scheme}://www.#{conn.host}"
  end

  # Returns whether the domain is bare (no www)
  defp bare_domain?(host) do
    !Regex.match?(~r/\Awww\..*\z/i, host)
  end
end