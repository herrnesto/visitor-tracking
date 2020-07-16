defmodule VisitorTracking.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: VisitorTracking.Repo
  alias VisitorTracking.{Accounts, Verification}

  def user_factory do
    %Accounts.User{
      uuid: UUID.uuid1(),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: Pbkdf2.hash_pwd_salt("testpass"),
      email_verified: false
    }
  end

  def profile_factory do
    %Accounts.Profile{
      firstname: "Test",
      lastname: "User",
      zip: "15500",
      city: "Athens",
      phone: "+10000000000",
      phone_verified: false
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
      code: "654321",
      mobile: "+10000000000"
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
end
