defmodule VisitorTracking.TwilioTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Twilio

  describe "format_response/2" do
    test "201" do
      assert {:ok, "sms was sent"} ==
               Twilio.format_response(
                 201,
                 '{"sid": "SMc270985b65f443d9af000abb1ee3b588", "date_created": "Fri, 31 Jul 2020 17:57:42 +0000", "date_updated": "Fri, 31 Jul 2020 17:57:42 +0000", "date_sent": null, "account_sid": "ACe808b673a9ec8700fe049815e199bc06", "to": "+41766401005", "from": "+41798077744", "messaging_service_sid": null, "body": "VESITA: Dein QR-Code kannst du hier abrufen: https://www.vesita.ch/qr/46cbd90c-d357-11ea-a3cc-5afd54bf7088", "status": "queued", "num_segments": "1", "num_media": "0", "direction": "outbound-api", "api_version": "2010-04-01", "price": null, "price_unit": "USD", "error_code": null, "error_message": null, "uri": "/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMc270985b65f443d9af000abb1ee3b588.json", "subresource_uris": {"media": "/2010-04-01/Accounts/ACe808b673a9ec8700fe049815e199bc06/Messages/SMc270985b65f443d9af000abb1ee3b588/Media.json"}}'
               )
    end

    test "400" do
      assert {:error, "Fehler: 400 - Diese Mobilnummer ist ungültig. Hast du dich vertippt?"} ==
               Twilio.format_response(
                 400,
                 '{"code": 21614, "message": "To number: +41799894492, is not a mobile number", "more_info": "https://www.twilio.com/docs/errors/21614", "status": 400}'
               )
    end

    test "404" do
      assert {:error, "Fehler: 404 - Diese Mobilnummer existiert nicht. Hast du dich vertippt?"} ==
               Twilio.format_response(
                 404,
                 '{"code": 20404, "message": "The requested resource /PhoneNumbers/0764709712 was not found", "more_info": "https://www.twilio.com/docs/errors/20404", "status": 404}'
               )
    end

    test "429" do
      assert {:error,
              "Fehler: 429 - Es wurden zu viele Anfragen an Twilio geschickt. Versuche es in einer Minute nochmals."} ==
               Twilio.format_response(
                 429,
                 '{"code": 20429, "message": "Too Many Requests", "more_info": "https://www.twilio.com/docs/errors/20429", "status": 429}'
               )
    end
  end
end
