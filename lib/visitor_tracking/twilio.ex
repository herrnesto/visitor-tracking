defmodule VisitorTracking.Twilio do
  @moduledoc """
  Twilio Context module
  """

  @validator Application.get_env(:visitor_tracking, :validator)

  alias __MODULE__.{Message, Response}

  def send_token(%{uri: uri, token: token} = args) do
    args
    |> Map.put(
      :message,
      "Dein Token lautet: #{token}  - Schliesse die Registrierung unter #{uri} ab."
    )
    |> send_message
  end

  def send_token(_), do: {:error, "missing params"}

  def send_qr(%{uri: uri} = args) do
    args
    |> Map.put(
      :message,
      "Bewahre diese SMS auf. Deinen QR-Code kannst du jederzeit hier abrufen: #{uri}"
    )
    |> send_message
  end

  def send_qr(_), do: {:error, "missing params"}

  def send_password_reset(%{uri: uri} = args) do
    args
    |> Map.put(:message, "Hier kannst du dein Passwort zurücksetzen: #{uri}")
    |> send_message
  end

  def send_password_reset(_), do: {:error, "missing params"}

  def send_message(%{message: message, target_number: target_number} = args) do
    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Response.log(response, args)

      {:ok, reponse_body} = Jason.decode(response)

      format_response(response.status_code, reponse_body)
    end
  end

  def format_response(201, _body), do: {:ok, "sms was sent"}

  def format_response(status_code, _body) when status_code == 400 do
    {:error, "Fehler: #{status_code} - Diese Mobilnummer ist ungültig. Hast du dich vertippt?"}
  end

  def format_response(status_code, _body) when status_code == 404 do
    {:error, "Fehler: #{status_code} - Diese Mobilnummer existiert nicht. Hast du dich vertippt?"}
  end

  def format_response(status_code, _body) when status_code == 429 do
    {:error,
     "Fehler: #{status_code} - Es wurden zu viele Anfragen an Twilio geschickt. Versuche es in einer Minute nochmals."}
  end

  def format_response(status_code, body) do
    {:error, "Fehler: #{status_code} - " <> Map.get(body, "message")}
  end

  def format_validation_response(200), do: :phone_verified

  def format_validation_response(404), do: :wrong_number

  def validate_phone(phone) do
    phone = String.replace(phone, " ", "")

    {:ok, response} = @validator.validate_phone(phone)
    Response.log(response, %{phone: phone})

    format_validation_response(response.status_code)
  end
end
