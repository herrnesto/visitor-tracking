defmodule VisitorTracking.Twilio do
  @moduledoc """
  Twilio Context module
  """

  @validator Application.get_env(:visitor_tracking, :validator)

  alias __MODULE__.{Message, Responses}

  def send_token(%{token: token, target_number: target_number} = args) do
    message = "VESITA: Dein Token lautet: #{token}"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_token(_), do: {:error, "missing params"}

  def send_qr(%{uuid: uuid, target_number: target_number} = args) do
    message =
      "VESITA: Bewahre diese SMS auf. Deinen QR-Code kannst du jederzeit hier abrufen: https://www.vesita.ch/qr/#{
        uuid
      }"

    with {:ok, response} <- Message.send(%{message: message, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

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
end
