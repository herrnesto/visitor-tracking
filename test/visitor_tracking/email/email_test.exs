defmodule VisitorTracking.EmailTest do
  use ExUnit.Case

  test "verification email" do
    email_address = "ralph@example.com"
    token = "123413"
    email = VisitorTracking.Email.verification_email(email_address, token)

    assert email.to == email_address
    assert email.html_body =~ "E-Mail-Adresse bestätigen"
    assert email.html_body =~ token
    assert email.text_body =~ "Rufe bitte folgenden Link in deinem Browser auf:"
    assert email.text_body =~ token
  end
end
