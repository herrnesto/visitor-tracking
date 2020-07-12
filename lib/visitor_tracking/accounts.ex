defmodule VisitorTracking.Accounts do
  alias VisitorTracking.Accounts.User
  alias VisitorTracking.Repo

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def authenticate_by_email_and_password(email, pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :wrong_password}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
