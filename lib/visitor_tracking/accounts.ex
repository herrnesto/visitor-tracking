defmodule VisitorTracking.Accounts do
  @moduledoc """
  Accounts Context module
  """

  alias VisitorTracking.Accounts.User
  alias VisitorTracking.{Events.Event, Repo, Verification}

  import Ecto.Query

  def get_user(id) when is_list(id) do
    query = from(p in User, where: p.id in ^id)
    Repo.all(query)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def authenticate_by_phone_and_password(phone, pass) do
    user = get_user_by(phone: String.replace(phone, " ", ""))

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
    %User{uuid: UUID.uuid1()}
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

  def verify_phone(visitor_id) do
    visitor_id
    |> get_user()
    |> User.phone_verification_changeset(%{phone_verified: true})
    |> Repo.update()
  end

  def get_all_events_from_scanner(id) do
    User
    |> Repo.get(id)
    |> Repo.preload([event_scanner: (from e in Event, order_by: [desc: e.date_start])])
  end
end
