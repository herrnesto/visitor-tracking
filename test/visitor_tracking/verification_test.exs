defmodule VisitorTracking.VerificationTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Factory
  alias VisitorTracking.Verification
  alias VisitorTracking.Verification.Token

  setup do
    %{user: Factory.insert(:user)}
  end

  describe "create_sms_code/2" do
    test "are different each time", %{user: user} do
      user_2 = insert(:user)
      assert {:ok, code_1} = Verification.create_sms_code(user.id, "+41791234567")
      assert {:ok, code_2} = Verification.create_sms_code(user_2.id, "+41791234567")
      refute code_1 == code_2
    end

    test "can not create 2 codes within a minute", %{user: user} do
      assert {:ok, code_1} = Verification.create_sms_code(user.id, "+41791234567")
      assert {:error, error} = Verification.create_sms_code(user.id, "+41791234567")
      assert :wait_before_recreate = error
    end
  end

  describe "sms_token_in_the_last_minute?/2" do
    test "is there a token not older than one minute", %{user: user} do
      mobile = "+41791234567"
      insert(:sms_token, user: user, mobile: mobile)
      assert Verification.sms_token_in_the_last_minute?(user.id, mobile)
    end

    test "there is no token created within the last minute", %{user: user} do
      mobile = "+41791234567"
      refute Verification.sms_token_in_the_last_minute?(user.id, mobile)
    end
  end

  describe "create link token" do
    test "success", %{user: user} do
      assert {:ok, _token} =
               Verification.create_link_token(user.id, "mark.renton@trainspotting.com")
    end

    test "are different each time", %{user: user} do
      assert {:ok, token_1} =
               Verification.create_link_token(user.id, "mark.renton@trainspotting.com")

      assert {:ok, token_2} =
               Verification.create_link_token(user.id, "mark.renton@trainspotting.com")

      refute token_1 == token_2
    end
  end

  describe "verify sms code" do
    test "valid", %{user: user} do
      {:ok, token} = Verification.create_sms_code(user.id, "+41791234567")

      assert {:ok, user.id} == Verification.verify_sms_code(token, "+41791234567")
    end

    test "not found" do
      assert {:error, _msg} = Verification.verify_sms_code("123456", "+41791234567")
    end

    test "expired", %{user: user} do
      time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-30 * 60)

      {:ok, code} = Verification.create_sms_code(user.id, "+41791234567")

      from(t in Token, where: t.user_id == ^user.id)
      |> Repo.update_all(set: [updated_at: time])

      assert {:error, _msg} = Verification.verify_sms_code(code, "+41791234567")
    end
  end

  describe "verify link token" do
    test "valid", %{user: user} do
      {:ok, token} = Verification.create_link_token(user.id, "mark.renton@trainspotting.com")

      assert {:ok, user.id} == Verification.verify_link_token(token)
    end

    test "not found" do
      assert {:error, _msg} = Verification.verify_link_token("ABCDEF123456")
    end

    test "expired", %{user: user} do
      time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-48 * 60 * 60)

      {:ok, token} = Verification.create_link_token(user.id, "mark.renton@trainspotting.com")

      from(t in Token, where: t.user_id == ^user.id)
      |> Repo.update_all(set: [updated_at: time])

      assert {:error, _msg} = Verification.verify_link_token(token)
    end
  end

  describe "get_token_by_email/1" do
    test "returns a token if it exists and valid" do
      %{id: id, email: email} = insert(:user)
      Verification.create_link_token(id, email)

      %Token{user_id: ^id} = Verification.get_token_by_email(email)
    end
  end
end
