defmodule VisitorTracking.AccountsTest do
  use VisitorTracking.DataCase, async: true
  alias VisitorTracking.Accounts

  describe "get_user_by/1" do
    test "returns nil if no user with that email exists" do
      assert nil == Accounts.get_user_by(email: "test@example.com")
    end

    test "returns a user that has that email" do
      %{id: id, email: email} = insert(:user)
      assert %{id: ^id} = Accounts.get_user_by(email: email)
    end
  end

  describe "get_user/1" do
    test "returns nil if no user exists with that id" do
      assert nil == Accounts.get_user(1000)
    end

    test "returns a user given an existing user id" do
      %{id: id} = insert(:user)
      assert %{id: ^id} = Accounts.get_user(id)
    end
  end
end
