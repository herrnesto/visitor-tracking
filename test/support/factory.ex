defmodule VisitorTracking.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: VisitorTracking.Repo
  alias VisitorTracking.{Accounts, Verification}

  def user_factory do
    %Accounts.User{
      uuid: UUID.uuid1(),
      password_hash: Pbkdf2.hash_pwd_salt("testpass"),
      phone: "+10000000000",
      phone_verified: false
    }
  end

  def profile_factory do
    %Accounts.Profile{
      user: insert(:user),
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
end
