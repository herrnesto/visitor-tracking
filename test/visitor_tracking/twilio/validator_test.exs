defmodule VisitorTracking.Twilio.ValidatorTest do
  use VisitorTracking.DataCase, async: true

  alias VisitorTracking.Twilio.Validator

  test "validate_phone/1 returns :valid if the phone is valid" do
    Validator.validate_phone("+41000000000")
  end
end
