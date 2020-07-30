defmodule VisitorTracking.Twilio do
  @moduledoc """
  Twilio Context module
  """

  alias VisitorTracking.Twilio.{Message, Responses}

  def send_token(%{token: token, target_number: target_number} = args) do
    message = "VESITA: Dein Token lautet: #{token}"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_qr(%{uuid: uuid, target_number: target_number} = args) do
    message = "VESITA: Dein QR-Code kannst du hier abrufen: https://www.vesita.ch/qr/#{uuid}"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_token(_), do: {:error, "missing params"}

  def format_response(201), do: {:ok, "sms was sent"}

  def format_response(status_code), do: {:error, "status_code: #{status_code}"}
end
