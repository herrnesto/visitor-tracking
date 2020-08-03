defmodule VisitorTracking.Twilio.InMemoryValidator do
  @moduledoc """
  In Memory Module for Twilio that validates a phone
  """

  def validate_phone("+41000000000") do
    {:ok,
     %HTTPoison.Response{
       body:
         "{\"caller_name\": null, \"country_code\": \"CH\", \"phone_number\": \"+41000000000\", \"national_format\": \"694 712 2245\", \"carrier\": null, \"add_ons\": null, \"url\": \"https://lookups.twilio.com/v1/PhoneNumbers/+41000000000\"}",
       status_code: 200
     }}
  end

  def validate_phone("+41111") do
    {:ok,
     %HTTPoison.Response{
       body:
         "{\"code\": 20404, \"message\": \"The requested resource /PhoneNumbers/+41111 was not found\", \"more_info\": \"https://www.twilio.com/docs/errors/20404\", \"status\": 404}",
       status_code: 404
     }}
  end
end
