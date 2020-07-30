defmodule VisitorTracking.Twilio.MessageTest do
  use VisitorTracking.DataCase, async: true

  alias VisitorTracking.Twilio.Message

  test "get_header" do
    result = %{
      Authorization: "Basic dGVzdDp0ZXN0",
      "Content-Type": "application/x-www-form-urlencoded"
    }

    assert header = Message.get_header()
    assert header = result
  end

  test "get_body" do
    token = "123466"
    message = "Dein Token zur Verifizerung lautet: #{token}"
    target_number = "+41791112209"

    result =
      {:form,
       [
         To: target_number,
         From: Application.fetch_env!(:visitor_tracking, :twilio_from),
         Body: "Dein Token zur Verifizerung lautet: #{token}"
       ]}

    assert body = Message.get_body(%{target_number: target_number, message: message})
    assert body = result
  end

  @doc """
  Refactor
  """
  test "send" do
    args = %{target_number: "+41790000000", message: "Dein Token zur Verifizerung lautet: 123466"}

    {:ok, _result} =
      {:ok,
       %HTTPoison.Response{
         body:
           "{\"sid\": \"SMf707980d40e54fa28e89908a77cc6b65\", \"date_created\": \"Sat, 11 Jul 2020 12:57:05 +0000\", \"date_updated\": \"Sat, 11 Jul 2020 12:57:05 +0000\", \"date_sent\": null, \"account_sid\": \"ACe808b673a9ec8700fe049815e199bc06\", \"to\": \"+41790000000\", \"from\": \"+12566175732\", \"messaging_service_sid\": null, \"body\": \"Sent from your Twilio trial account - Dein Token zur Verifizerung lautet: 123466\", \"status\": \"queued\", \"num_segments\": \"1\", \"num_media\": \"0\", \"direction\": \"outbound-api\", \"api_version\": \"2010-04-01\", \"price\": null, \"price_unit\": \"USD\", \"error_code\": null, \"error_message\": null, \"uri\": \"/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMf707980d40e54fa28e89908a77cc6b65.json\", \"subresource_uris\": {\"media\": \"/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMf707980d40e54fa28e89908a77cc6b65/Media.json\"}}",
         headers: [
           {"Date", "Sat, 11 Jul 2020 12:57:05 GMT"},
           {"Content-Type", "application/json"},
           {"Content-Length", "844"},
           {"Connection", "keep-alive"},
           {"Twilio-Concurrent-Requests", "1"},
           {"Twilio-Request-Id", "RQ5964c5649eed4d25a405e35c2df3b8f4"},
           {"Twilio-Request-Duration", "0.127"},
           {"Access-Control-Allow-Origin", "*"},
           {"Access-Control-Allow-Headers",
            "Accept, Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since"},
           {"Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS"},
           {"Access-Control-Expose-Headers", "ETag"},
           {"Access-Control-Allow-Credentials", "true"},
           {"X-Powered-By", "AT-5000"},
           {"X-Shenanigans", "none"},
           {"X-Home-Region", "us1"},
           {"X-API-Domain", "api.twilio.com"},
           {"Strict-Transport-Security", "max-age=31536000"}
         ],
         request: %HTTPoison.Request{
           body:
             {:form,
              [
                To: "+41790000000",
                From: "12566175732",
                Body: "Dein Token zur Verifizerung lautet: 123466"
              ]},
           headers: [
             Authorization:
               "Basic QUNlODA4YjY3M2E5ZWM4NzAwZmUwNDk4MTVlMTk5YmMwNjo3OGVlNmMxMTA0Yjk1NDE3NWI5NGQxZDY3ODIyZDkxYg==",
             "Content-Type": "application/x-www-form-urlencoded"
           ],
           method: :post,
           options: [],
           params: %{},
           url:
             "https://api.twilio.com/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages.json"
         },
         request_url:
           "https://api.twilio.com/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages.json",
         status_code: 201
       }}

    assert {:ok, response} = Message.send(args)

    # assert result.body = response.body
  end
end
