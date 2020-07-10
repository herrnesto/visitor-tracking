defmodule VisitorTracking.EmailTest do
  use ExUnit.Case

  test "verification email" do
    user = {"Ralph", "ralph@example.com"}

    email = VisitorTracking.Email.verification_email(user)

    assert email.to == user
    assert email.html_body =~ "Verification code"
    assert email.text_body =~ "Verification code"
  end
end
