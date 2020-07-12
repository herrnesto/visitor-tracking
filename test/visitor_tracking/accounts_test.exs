defmodule VisitorTracking.AccountsTest do
  use VisitorTracking.DataCase, async: true
  alias VisitorTracking.{Accounts, Verification}

  @valid_user_params %{
    email: "test_email@example.com",
    password: "anotherpassword",
    password_confirmation: "anotherpassword"
  }

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

  describe "change_user/1" do
    test "returns an invalid changeset if params are empty" do
      assert %Ecto.Changeset{valid?: false} = Accounts.change_user()
      assert %Ecto.Changeset{valid?: false} = Accounts.change_user(%{})
    end

    test "returns a changeset with errors if password and confirmation do not match" do
      assert %Ecto.Changeset{errors: errors} =
               Accounts.change_user(%{
                 email: "test@example.com",
                 password: "anotherpassword",
                 password_confirmation: "differentpass"
               })

      assert errors != []
    end

    test "returns a changeset with errors if confirmation is missing" do
      assert %Ecto.Changeset{errors: errors} =
               Accounts.change_user(%{
                 email: "test_email@example.com",
                 password: "anotherpassword"
               })

      assert errors != []
    end

    test "returns a valid changeset if all params are valid" do
      assert %Ecto.Changeset{valid?: true} = Accounts.change_user(@valid_user_params)
    end
  end

  describe "change_user/2" do
    test "returns a changeset with no changes if params are empty" do
      user = insert(:user)
      assert %Ecto.Changeset{changes: %{}} = Accounts.change_user(user, %{})
    end
  end

  describe "create_user/1" do
    test "returns {:ok, user} if params are valid" do
      assert {:ok, user} = Accounts.create_user(@valid_user_params)
    end

    test "returns {:error, changeset} if params are empty" do
      assert {:error, _} = Accounts.create_user(%{})
    end

    test "returns {:error, changeset} if params are wrong" do
      assert {:error, _} =
               Accounts.create_user(%{
                 email: "test@example.com",
                 password: "testpass",
                 password_confirmation: "anotherpass"
               })
    end
  end

  describe "verify_email_by_token/1" do
    test "verifies email of a user if token is valid" do
      %{id: id, email: email, email_verified: false} = insert(:user)
      {:ok, token} = Verification.create_link_token(id, email)
      assert {:ok, user} = Accounts.verify_email_by_token(token)
      assert user.email_verified == true
    end
  end

  describe "change_profile/2" do
    test "returns a changeset of an empty profile for a user" do
      %{id: id} = insert(:user)
      assert %Ecto.Changeset{changes: %{user_id: ^id}} = Accounts.change_profile(id)
    end
  end
end
