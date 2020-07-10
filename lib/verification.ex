defmodule VisitorTracking.Verification do
  alias VisitorTracking.Repo
  alias VisitorTracking.Verification.Token

  import Ecto.Query

  # 15 min
  @sms_expire_threshold 15 * 60

  # 24 hours
  @link_expire_threshold 24 * 60 * 60

  def create_sms_code(visitor_id, mobile) do
    case create_token(%{
           type: "sms",
           visitor_id: visitor_id,
           mobile: mobile,
           code: generate_code(mobile)
         }) do
      {:ok, token} -> {:ok, token.code}
      error -> error
    end
  end

  def create_link_token(visitor_id, email) do
    case create_token(%{
           type: "link",
           visitor_id: visitor_id,
           email: email,
           token: generate_token(email)
         }) do
      {:ok, token} -> {:ok, token.token}
      error -> error
    end
  end

  def verify_sms_code(code, mobile) do
    case get_valid_sms_token(code, mobile) do
      nil -> {:error, "code not found or expired"}
      token -> {:ok, token.visitor_id}
    end
  end

  def verify_link_token(token) do
    case get_valid_link_token(token) do
      nil -> {:error, "token not found or expired"}
      token -> {:ok, token.visitor_id}
    end
  end

  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  def get_valid_sms_token(code, mobile) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-@sms_expire_threshold)

    from(t in Token,
      where: t.mobile == ^mobile,
      where: t.code == ^code,
      where: t.updated_at > ^time
    )
    |> Repo.one()
  end

  def get_valid_link_token(token) do
    time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-@link_expire_threshold)

    from(t in Token,
      where: t.token == ^token,
      where: t.updated_at > ^time
    )
    |> Repo.one()
  end

  def get_token_by_code(code, mobile) do
    from(t in Token,
      where: t.mobile == ^mobile,
      where: t.code == ^Integer.to_string(code)
    )
    |> Repo.one()
  end

  defp check_code(1_000_000, mobile), do: check_code(1, mobile)

  defp check_code(code, mobile) do
    case get_token_by_code(code, mobile) do
      nil -> code
      _ -> check_code(code + 1, mobile)
    end
  end

  defp generate_code(mobile) do
    :rand.uniform(999_999)
    |> check_code(mobile)
    |> Integer.to_string()
    |> String.pad_leading(6, "0")
  end

  defp generate_token(email) do
    key = Time.utc_now() |> Time.to_string()

    :crypto.hmac(:sha256, key, email)
    |> Base.encode16()
  end
end
