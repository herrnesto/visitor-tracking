defmodule VisitorTrackingWeb.QrController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts}

  def show(conn, %{"uuid" => uuid}) do
    code =
      Accounts.get_user(uuid)
      |> generate_qrcode()

    render(conn, "show.html", %{qrcode: code})
  end

  # or create a fake number
  defp generate_qrcode(nil),
    do:
      generate_qrcode(
        Enum.random(
          10_000_000_000_000_000_000_000_000_000..100_000_000_000_000_000_000_000_000_000
        )
        |> Integer.to_string()
      )

  defp generate_qrcode(%Accounts.User{} = user), do: generate_qrcode(user.uuid)

  defp generate_qrcode(uuid) do
    data =
      uuid
      |> IO.inspect()
      |> EQRCode.encode()
      |> EQRCode.png()
      |> Base.encode64()

    "data:image/png;base64," <> data
  end
end