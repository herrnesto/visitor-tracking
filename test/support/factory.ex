defmodule VisitorTracking.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: VisitorTracking.Repo
  alias VisitorTracking.Accounts

  def user_factory do
    %Accounts.User{
      id: 3,
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: Pbkdf2.hash_pwd_salt("testpass"),
      email_verified: false
    }
  end
end
