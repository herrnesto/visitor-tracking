defmodule VisitorTracking.Twilio.Message do
  @moduledoc """
  Module for Twilio that composes and send a text message.
  """

  alias VisitorTracking.Twilio.InMemoryApi

  @api_url "https://api.twilio.com/2010-04-01/Accounts/"

  def send(args) do
    with header <- get_header(),
         body <- get_body(args) do
      post(Mix.env(), get_url(), body, header)
    end
  end

  def get_body(%{target_number: target_number, message: message}) do
    from = Application.fetch_env!(:visitor_tracking, :twilio_from)

    {:form, [To: target_number, From: from, Body: message]}
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

  def get_url do
    @api_url <>
      Application.fetch_env!(:visitor_tracking, :twilio_account_sid) <> "/Messages.json"
  end

  def post(:test, url, body, header), do: InMemoryApi.post(url, body, header, [])

  def post(_, url, body, header), do: HTTPoison.post(url, body, header, [])
end
