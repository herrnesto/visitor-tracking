defmodule VisitorTracking.PasswordTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Password
  alias VisitorTracking.Password.Token


  describe "create_token/1" do
    test "are different each time" do
      assert {:ok, code_1} = Password.create_token("+41791234567")
      assert {:ok, code_2} = Password.create_token("+41791234568")
      refute code_1 == code_2
    end

    test "can not create 2 codes within a minute" do
      assert {:ok, code_1} = Password.create_token("+41791234567")
      assert {:error, error} = Password.create_token("+41791234567")
      assert :wait_before_recreate = error
    end
  end

  describe "has_unexpired_token?/1" do
    test "is there a token not older than defined time minute" do
      mobile = "+41791234567"
      insert(:password_token, mobile: mobile)
      assert Password.has_unexpired_token?(mobile)
    end

    test "there is no token created within the last minute" do
      mobile = "+41791234567"
      refute Password.has_unexpired_token?(mobile)
    end
  end

  describe "verify_token/1" do
    test "valid" do
      mobile = "+41791234567"
      {:ok, token} = Password.create_token("+41791234567")

      assert {:ok, mobile} == Password.verify_token(token)
    end

    test "not found" do
      assert {:error, _msg} = Password.verify_token("232345")
    end

    test "expired" do
      time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-30 * 60)

      {:ok, token} = Password.create_token("+41791234567")

      from(t in Token, where: t.token == ^token)
      |> Repo.update_all(set: [updated_at: time])

      assert {:error, _msg} = Password.verify_token(token)
    end
  end
end
