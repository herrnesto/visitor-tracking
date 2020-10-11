defmodule VisitorTracking.Twilio do
  @moduledoc """
  Twilio Context module
  """

  @validator Application.get_env(:visitor_tracking, :validator)

  alias __MODULE__.{Message, Responses}

  def send_token(%{token: token, target_number: target_number} = args) do
    message = "Dein Token lautet: #{token}  - Schliesse die Registrierung unter #{get_website_url()} ab."

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_token(_), do: {:error, "missing params"}

  def send_qr(%{uuid: uuid, target_number: target_number} = args) do
    message =
      "Bewahre diese SMS auf. Deinen QR-Code kannst du jederzeit hier abrufen: #{get_website_url()}/qr/#{
        uuid
      }"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_token(_), do: {:error, "missing params"}

  def send_password_reset(%{url: url, target_number: target_number} = args) do
    message = "Hier kannst du dein Passwort zurücksetzen: #{get_website_url()}/#{url}"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_password_reset(_), do: {:error, "missing params"}

  def format_response(201), do: {:ok, "sms was sent"}

  def format_response(status_code), do: {:error, "status_code: #{status_code}"}

  def format_validation_response(200), do: :phone_verified
  def format_validation_response(404), do: :wrong_number

  def validate_phone(phone) do
    phone = String.replace(phone, " ", "")

    {:ok, response} = @validator.validate_phone(phone)
    Responses.log(response, %{phone: phone})

    format_validation_response(response.status_code)
  end

  defp get_website_url do
    get_protocol() <> get_host() <> ""
  end

  defp get_protocol do
    Application.get_env(:visitor_tracking, :protocol)
  end

  defp get_host do
    Application.get_env(:visitor_tracking, :host)
  end
end
