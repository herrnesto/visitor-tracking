defmodule VisitorTracking.Twilio.Validator do
  @moduledoc """
  Module for Twilio that validates a phone
  """

  @api_url "https://lookups.twilio.com/v1/PhoneNumbers"

  def validate_phone(phone) do
    HTTPoison.get("#{@api_url}/#{phone}", get_header())
  end

  def get_header do
    auth_string =
      Base.encode64(
        Application.fetch_env!(:visitor_tracking, :twilio_account_sid) <>
          ":" <> Application.fetch_env!(:visitor_tracking, :twilio_auth_token)
      )

    %{
      Authorization: "Basic #{auth_string}",
      "Content-Type": "application/x-www-form-urlencoded"
    }
  end
end
