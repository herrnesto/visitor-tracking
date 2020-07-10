defmodule VisitorTracking.VerificationTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Verification
  alias VisitorTracking.Verification.Token

  describe "create sms code" do
    test "success" do
      assert {:ok, _code} = Verification.create_sms_code(1, "+41791234567")
    end

    test "missing plus in mobile number" do
      assert {:error, _msg} = Verification.create_sms_code(1, "0791234567")
    end

    test "are different each time" do
      assert {:ok, code_1} = Verification.create_sms_code(1, "+41791234567")
      assert {:ok, code_2} = Verification.create_sms_code(1, "+41791234567")
      refute code_1 == code_2
    end
  end

  describe "create link token" do
    test "success" do
      assert {:ok, _token} = Verification.create_link_token(1, "mark.renton@trainspotting.com")
    end

    test "invalid email" do
      assert {:error, _msg} = Verification.create_link_token(1, "mark.renton@ts,com")
    end

    test "are different each time" do
      assert {:ok, token_1} = Verification.create_link_token(1, "mark.renton@trainspotting.com")
      assert {:ok, token_2} = Verification.create_link_token(1, "mark.renton@trainspotting.com")
      refute token_1 == token_2
    end
  end

  describe "verify sms code" do
    test "valid" do
      {:ok, token} = Verification.create_sms_code(1, "+41791234567")

      assert {:ok, 1} == Verification.verify_sms_code(token, "+41791234567")
    end

    test "not found" do
      assert {:error, _msg} = Verification.verify_sms_code("123456", "+41791234567")
    end

    test "expired" do
      time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-30 * 60)

      {:ok, code} = Verification.create_sms_code(1, "+41791234567")

      from(t in Token, where: t.visitor_id == 1)
      |> Repo.update_all(set: [updated_at: time])

      assert {:error, _msg} = Verification.verify_sms_code(code, "+41791234567")
    end
  end

  describe "verify link token" do
    test "valid" do
      {:ok, token} = Verification.create_link_token(1, "mark.renton@trainspotting.com")

      assert {:ok, 1} == Verification.verify_link_token(token)
    end

    test "not found" do
      assert {:error, _msg} = Verification.verify_link_token("ABCDEF123456")
    end

    test "expired" do
      time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-48 * 60 * 60)

      {:ok, token} = Verification.create_link_token(1, "mark.renton@trainspotting.com")

      from(t in Token, where: t.visitor_id == 1)
      |> Repo.update_all(set: [updated_at: time])

      assert {:error, _msg} = Verification.verify_link_token(token)
    end
  end
end
