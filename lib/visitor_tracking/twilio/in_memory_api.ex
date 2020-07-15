defmodule VisitorTracking.Twilio.InMemoryApi do
  @moduledoc """
  Simulates Twilio API without doing real calls.
  """

  def post(url, _body, header, _options) do
    {:ok,
     %HTTPoison.Response{
       body:
         "{\"sid\": \"SMf707980d40e54fa28e89908a77cc6b65\", \"date_created\": \"Sat, 11 Jul 2020 12:57:05 +0000\", \"date_updated\": \"Sat, 11 Jul 2020 12:57:05 +0000\", \"date_sent\": null, \"account_sid\": \"ACe808b673a9ec8700fe049815e199bc06\", \"to\": \"+41793154409\", \"from\": \"+12566175732\", \"messaging_service_sid\": null, \"body\": \"Sent from your Twilio trial account - Dein Token zur Verifizerung lautet: 123466\", \"status\": \"queued\", \"num_segments\": \"1\", \"num_media\": \"0\", \"direction\": \"outbound-api\", \"api_version\": \"2010-04-01\", \"price\": null, \"price_unit\": \"USD\", \"error_code\": null, \"error_message\": null, \"uri\": \"/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMf707980d40e54fa28e89908a77cc6b65.json\", \"subresource_uris\": {\"media\": \"/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMf707980d40e54fa28e89908a77cc6b65/Media.json\"}}",
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
              To: "+41793154409",
              From: "12566175732",
              Body: "Dein Token zur Verifizerung lautet: 123466"
            ]},
         headers: [
           Authorization: Map.get(header, :Authorization),
           "Content-Type": Map.get(header, :"Content-Type")
         ],
         method: :post,
         options: [],
         params: %{},
         url: url
       },
       request_url: url,
       status_code: 201
     }}
  end
end
