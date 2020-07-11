defmodule VisitorTracking.Twilio do
  def test do
    VisitorTracking.Twilio.Message.send_token(%{token: "123466", target_number: "+41793154409"})
  end
end
