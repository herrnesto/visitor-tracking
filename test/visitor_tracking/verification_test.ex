defmodule VisitorTracking.VerificationTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Verification

  describe "create sms code" do
    test "success" do
      assert {:ok, "123456"} == Verification.create_sms_code(1, "+41791234567")
    end
  end

  describe "create link token" do
    test "success" do
      assert {:ok, "F7BC83F430538424B13298E6AA6FB143EF4D59A14946175997479DBC2D1A3CD8"} ==
               Verification.create_link_token(1, "mark.renton@trainspotting.com")
    end
  end

  describe "verify sms code" do
    test "valid" do
      assert {:ok, 1} == Verification.verify_sms_code("123456", "+41791234567")
    end
  end

  describe "verify link token" do
    test "valid" do
      assert {:ok, 1} ==
               Verification.verify_link_token(
                 "F7BC83F430538424B13298E6AA6FB143EF4D59A14946175997479DBC2D1A3CD8"
               )
    end
  end
end
