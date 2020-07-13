defmodule VisitorTracking.Accounts do
  @moduledoc """
  Accounts Context module
  """

  alias VisitorTracking.Accounts.{Profile, User}
  alias VisitorTracking.{Repo, Verification}

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

  def change_user(params \\ %{}) do
    User.registration_changeset(%User{}, params)
  end

  def change_user(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def create_user(params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end

  def verify_email_by_token(token) do
    with {:ok, visitor_id} <- Verification.verify_link_token(token),
         user <- get_user(visitor_id) do
      user
      |> User.email_verification_changeset(%{email_verified: true})
      |> Repo.update()
    else
      {:error, reason} ->
        {:error, reason}

      nil ->
        {:error, :user_not_found}
    end
  end

  def change_profile(user_id, params \\ %{}) do
    params = Map.put_new(params, :user_id, user_id)
    Profile.changeset(%Profile{}, params)
  end

  def create_profile(params) do
    %Profile{}
    |> Profile.changeset(params)
    |> Repo.insert()
  end
end
