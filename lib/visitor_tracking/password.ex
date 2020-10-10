defmodule VisitorTracking.Password do
  @moduledoc false

  alias VisitorTracking.Repo
  alias VisitorTracking.Password.Token

  import Ecto.Query

  # 15 min
  @token_expire_threshold 5 * 60

  def create_token(mobile) do
    with false <- has_unexpired_token?(mobile),
         {:ok, token} <-
           create_password_token(%{
             mobile: mobile,
             token: generate_token(mobile)
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
      token -> {:ok, token.mobile}
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

  defp generate_token(mobile) do
    key = Time.utc_now() |> Time.to_string()

    :crypto.hmac(:sha256, key, mobile)
    |> Base.encode16()
  end

  def has_unexpired_token?(mobile) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-@token_expire_threshold)

    from(t in Token,
      where: t.mobile == ^mobile,
      where: t.inserted_at > ^time,
      limit: 1
    )
    |> Repo.one()
    |> case do
         nil -> false
         _ -> true
       end
  end
end