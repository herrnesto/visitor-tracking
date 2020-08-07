defmodule VisitorTracking.FormTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Form

  describe "contact_forms" do
    alias VisitorTracking.Form.ContactForm

    @valid_attrs %{email: "mans@huster.email", message: "some message", name: "some name"}
    @update_attrs %{
      email: "mans2@huster.email",
      message: "some updated message",
      name: "some updated name"
    }
    @invalid_attrs %{email: nil, message: nil, name: nil}

    def contact_form_fixture(attrs \\ %{}) do
      {:ok, contact_form} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Form.create_contact_form()

      contact_form
    end

    test "list_contact_forms/0 returns all contact_forms" do
      contact_form = contact_form_fixture()
      assert Form.list_contact_forms() == [contact_form]
    end

    test "get_contact_form!/1 returns the contact_form with given id" do
      contact_form = contact_form_fixture()
      assert Form.get_contact_form!(contact_form.id) == contact_form
    end

    test "create_contact_form/1 with valid data creates a contact_form" do
      assert {:ok, %ContactForm{} = contact_form} = Form.create_contact_form(@valid_attrs)
      assert contact_form.email == "mans@huster.email"
      assert contact_form.message == "some message"
      assert contact_form.name == "some name"
    end

    test "create_contact_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Form.create_contact_form(@invalid_attrs)
    end

    test "create_contact_form/1 with invalid email returns error changeset" do
      attrs = Map.put(@invalid_attrs, :email, "dfsdf")
      assert {:error, %Ecto.Changeset{}} = Form.create_contact_form(attrs)
    end

    test "update_contact_form/2 with valid data updates the contact_form" do
      contact_form = contact_form_fixture()

      assert {:ok, %ContactForm{} = contact_form} =
               Form.update_contact_form(contact_form, @update_attrs)

      assert contact_form.email == "mans2@huster.email"
      assert contact_form.message == "some updated message"
      assert contact_form.name == "some updated name"
    end

    test "update_contact_form/2 with invalid data returns error changeset" do
      contact_form = contact_form_fixture()
      assert {:error, %Ecto.Changeset{}} = Form.update_contact_form(contact_form, @invalid_attrs)
      assert contact_form == Form.get_contact_form!(contact_form.id)
    end

    test "delete_contact_form/1 deletes the contact_form" do
      contact_form = contact_form_fixture()
      assert {:ok, %ContactForm{}} = Form.delete_contact_form(contact_form)
      assert_raise Ecto.NoResultsError, fn -> Form.get_contact_form!(contact_form.id) end
    end

    test "change_contact_form/1 returns a contact_form changeset" do
      contact_form = contact_form_fixture()
      assert %Ecto.Changeset{} = Form.change_contact_form(contact_form)
    end
  end
end
