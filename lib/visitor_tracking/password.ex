defmodule VisitorTracking.Password do
  @moduledoc false

  alias VisitorTracking.{Accounts, Repo}
  alias VisitorTracking.Accounts.User
  alias VisitorTracking.Password.Token

  import Ecto.Query

  # 15 min
  @token_expire_threshold 15 * 60

  def create_token(phone) do
    phone = String.replace(phone, " ", "")

    with false <- has_unexpired_token?(phone),
         {:ok, token} <-
           create_password_token(%{
             phone: phone,
             token: generate_token(phone)
           }) do
      {:ok, token.token}
    else
      true -> {:error, :wait_before_recreate}
    end
  end

  def create_password_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  def verify_token(token) do
    case get_valid_token(token) do
      nil -> {:error, "token not found or expired"}
      token -> {:ok, token.phone}
    end
  end

  def get_valid_token(token) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-@token_expire_threshold)

    from(t in Token,
      where: t.token == ^token,
      where: t.updated_at > ^time
    )
    |> Repo.one()
  end

  defp generate_token(phone) do
    key = Time.utc_now() |> Time.to_string()

    :crypto.hmac(:sha256, key, phone)
    |> Base.encode16()
  end

  def has_unexpired_token?(phone) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-@token_expire_threshold)

    from(t in Token,
      where: t.phone == ^phone,
      where: t.inserted_at > ^time,
      limit: 1
    )
    |> Repo.one()
    |> case do
      nil -> false
      _ -> true
    end
  end

  def change_user_password(token, user_params) do
    token = get_valid_token(token)

    %{phone: token.phone}
    |> Accounts.get_user_by()
    |> User.change_password_changeset(user_params)
    |> Repo.update()
  end
end
