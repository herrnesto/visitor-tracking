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

  test "emergency_email" do
    recipient_email = "pexeg@mailinator.com"
    recipient_name = "Dr. Pill"

    data = %{
      "event_id" => "5",
      "initiator_id" => 1,
      "recipient_email" => recipient_email,
      "recipient_name" => recipient_name,
      "visitors" => [
        %VisitorTracking.Accounts.User{
          city: "brugg",
          email: "simon@daddsad.com",
          email_verified: false,
          firstname: "Mans",
          id: 2,
          inserted_at: ~N[2020-08-04 19:31:22],
          lastname: "huster",
          password: nil,
          password_confirmation: nil,
          password_hash:
            "$pbkdf2-sha512$160000$cm6fvT0dNyZQd5/0YZZfMw$Xw9URFhR2Lyl/P23Esjzt2ExmF2RvQgMffRU6Q5Z6ytDPm9nwxAwal0Tq/ghl5uVLLj.y8sPMSUSXytgE.nz.w",
          phone: "+49793154408",
          phone_verified: true,
          role: "user",
          updated_at: ~N[2020-08-04 19:33:44],
          uuid: "137216f4-d689-11ea-8ebd-784f439a034a",
          zip: "6000"
        },
        %VisitorTracking.Accounts.User{
          city: "Mollit",
          email: "tymyce@mailinator.com",
          email_verified: false,
          firstname: "Basia",
          id: 3,
          inserted_at: ~N[2020-08-12 21:17:08],
          lastname: "Thornton",
          password: nil,
          password_confirmation: nil,
          password_hash:
            "$pbkdf2-sha512$160000$p4jtkaXDCqoxEDfpS.MMtA$35xWG4TjLyylMUkW5bbRcV/p2KgK6DDH3ed2nVzVf652cUAgINLJnyZ8IEsd/wIJu6G4fDg5NKcglj6kIjpIKw",
          phone: "+41793154408",
          phone_verified: true,
          role: "user",
          updated_at: ~N[2020-08-12 21:17:08],
          uuid: "2d488b9a-dce1-11ea-ac2b-784f439a034a",
          zip: "1785"
        }
      ]
    }

    email = VisitorTracking.Email.emergency_email(data)
    assert email.to =~ recipient_email
    assert email.subject =~ "Contact Tracing Daten"
    assert email.html_body =~ "Hallo " <> recipient_name

    assert email.html_body =~ "<td>Basia</td>"
    assert email.html_body =~ "<td>Thornton</td>"
    assert email.html_body =~ "<td>+41793154408</td>"
    assert email.html_body =~ "<td>1785</td>"
    assert email.html_body =~ "<td>Mollit</td>"
    
    assert email.text_body =~ "Basia"
    assert email.text_body =~ "Thornton"
    assert email.text_body =~ "+41793154408"
    assert email.text_body =~ "1785"
    assert email.text_body =~ "Mollit"


    assert email.html_body =~ "<td>Mans</td>"
    assert email.html_body =~ "<td>huster</td>"
    assert email.html_body =~ "<td>+49793154408</td>"
    assert email.html_body =~ "<td>6000</td>"
    assert email.html_body =~ "<td>brugg</td>"
    assert email.html_body =~ "<td>simon@daddsad.com</td>"

    assert email.text_body =~ "Mans"
    assert email.text_body =~ "huster"
    assert email.text_body =~ "+49793154408"
    assert email.text_body =~ "6000"
    assert email.text_body =~ "brugg"
    assert email.text_body =~ "simon@daddsad.com"
  end
end
