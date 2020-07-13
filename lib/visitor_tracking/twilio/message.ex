defmodule VisitorTracking.Twilio.Message do
  @moduledoc """
  Module for Twilio that composes and send a text message.
  """

  alias VisitorTracking.Twilio.InMemoryApi

  @api_url "https://api.twilio.com/2010-04-01/Accounts/"

  def send_token(args) do
    with header <- get_header(),
         body <- get_body(args) do
      post(Mix.env(), get_url(), body, header)
    end
  end

  def get_body(%{target_number: target_number, token: token} = args) do
    from_number = Application.fetch_env!(:visitor_tracking, :twilio_from)

    {:form,
     [To: target_number, From: from_number, Body: "Dein Token zur Verifizerung lautet: #{token}"]}
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
