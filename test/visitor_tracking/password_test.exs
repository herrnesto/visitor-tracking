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
      phone = "+41791234567"
      insert(:password_token, phone: phone)
      assert Password.has_unexpired_token?(phone)
    end

    test "there is no token created within the last minute" do
      phone = "+41791234567"
      refute Password.has_unexpired_token?(phone)
    end
  end

  describe "verify_token/1" do
    test "valid" do
      phone = "+41791234567"
      {:ok, token} = Password.create_token(phone)

      assert {:ok, phone} == Password.verify_token(token)
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

  describe "change_password/2" do
    test "successfull change pasword" do
      %{password: password_orig, password_hash: password_hash_orig} = user = insert(:user)

      {:ok, token} = Password.create_token(user.phone)

      assert {:ok, %{password: password, password_hash: password_hash}} =
               Password.change_user_password(token, %{
                 "password" => "00000000",
                 "password_confirmation" => "00000000"
               })

      refute password_orig == password
      refute password_hash_orig == password_hash
    end

    test "failed change pasword" do
      user = insert(:user)

      {:ok, token} = Password.create_token(user.phone)

      assert {:error, changeset} =
               Password.change_user_password(token, %{
                 "password" => "00000000",
                 "password_confirmation" => "11111111"
               })
    end
  end
end
