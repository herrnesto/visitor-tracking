defmodule VisitorTracking.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: VisitorTracking.Repo
  alias VisitorTracking.{Accounts, Events, Verification, Emergencies}

  def user_factory do
    %Accounts.User{
      uuid: UUID.uuid1(),
      password_hash: Pbkdf2.hash_pwd_salt("testpass"),
      phone: sequence(:number, &"+10#{&1}00#{&1}00000"),
      phone_verified: false,
      firstname: "Test",
      lastname: "User",
      zip: "15500",
      city: "Athens",
      email: sequence(:email, &"email-#{&1}@example.com"),
      email_verified: false
    }
  end

  def email_token_factory do
    key = Time.utc_now() |> Time.to_string()
    email = sequence(:email, &"email-#{&1}@example.com")

    token =
      :crypto.hmac(:sha256, key, email)
      |> Base.encode16()

    %Verification.Token{
      user: insert(:user),
      type: "link",
      token: token,
      email: email,
      code: nil,
      mobile: nil
    }
  end

  def sms_token_factory do
    %Verification.Token{
      user: insert(:user),
      type: "sms",
      token: nil,
      email: nil,
      code: "654321",
      mobile: "+10000000000"
    }
  end

  def event_factory do
    %Events.Event{
      organiser: insert(:user),
      name: "Test Event",
      venue: "Test Venue",
      visitor_limit: 100,
      date_start: NaiveDateTime.utc_now(),
      status: "created"
    }
  end

  def scanner_factory do
    %{id: event_id} = insert(:event)
    %{id: user_id} = insert(:user, email_verified: true, phone_verified: true)

    %Events.Scanner{
      event_id: event_id,
      user_id: user_id,
      enabled: true
    }
  end

  def visitor_action_factory(
        %{action: action, event_id: event_id, user_id: user_id, inserted_at: inserted_at} = _attrs
      ) do
    %Events.Action{
      event_id: event_id,
      user_id: user_id,
      action: action,
      inserted_at: inserted_at
    }
  end

  def emergency_factory(%{event_id: event_id, user_id: user_id} = _attrs) do
    %Emergencies.Emergency{
      event_id: event_id,
      initiator_id: user_id,
      recipient_name: "Dr. Pill",
      recipient_email: "doctor@gov.com"
    }
  end
end
