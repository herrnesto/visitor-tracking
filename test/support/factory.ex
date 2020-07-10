defmodule VisitorTracking.Factory do
  use ExMachina.Ecto, repo: VisitorTracking.Repo
  alias VisitorTracking.Accounts

  def user_factory do
    %Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: Pbkdf2.hash_pwd_salt("testpass"),
      email_verified: false
    }
  end
end
