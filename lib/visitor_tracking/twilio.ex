defmodule VisitorTracking.Twilio do
  @moduledoc """
  Twilio Context module
  """

  alias VisitorTracking.Twilio.{Responses, Message}

  def send_token(%{token: token, target_number: target_number} = args) do
    with {:ok, response} <- Message.send_token(%{token: token, target_number: target_number}) do
      Responses.log(response, args)

      format_response(response.status_code)
    end
  end

  def send_token(_), do: {:error, "missing params"}

  def format_response(201), do: {:ok, "sms was sent"}

  def format_response(status_code), do: {:error, "status_code: #{status_code}"}
end
