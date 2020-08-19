defmodule VisitorTracking.EmergenciesTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Emergencies

  describe "emergencies" do
    alias VisitorTracking.Emergencies.Emergency

    @valid_attrs %{recipient_email: "some recipient_email", recipient_name: "some recipient_name"}
    @update_attrs %{
      recipient_email: "some updated recipient_email",
      recipient_name: "some updated recipient_name"
    }
    @invalid_attrs %{recipient_email: nil, recipient_name: nil}

    def emergency_fixture(attrs \\ %{}) do
      {:ok, emergency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Emergencies.create_emergency()

      emergency
    end

    test "list_emergencies/0 returns all emergencies" do
      emergency = emergency_fixture()
      assert Emergencies.list_emergencies() == [emergency]
    end

    test "get_emergency!/1 returns the emergency with given id" do
      emergency = emergency_fixture()
      assert Emergencies.get_emergency!(emergency.id) == emergency
    end

    test "create_emergency/1 with valid data creates a emergency" do
      assert {:ok, %Emergency{} = emergency} = Emergencies.create_emergency(@valid_attrs)
      assert emergency.recipient_email == "some recipient_email"
      assert emergency.recipient_name == "some recipient_name"
    end

    test "create_emergency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Emergencies.create_emergency(@invalid_attrs)
    end

    test "update_emergency/2 with valid data updates the emergency" do
      emergency = emergency_fixture()

      assert {:ok, %Emergency{} = emergency} =
               Emergencies.update_emergency(emergency, @update_attrs)

      assert emergency.recipient_email == "some updated recipient_email"
      assert emergency.recipient_name == "some updated recipient_name"
    end

    test "update_emergency/2 with invalid data returns error changeset" do
      emergency = emergency_fixture()
      assert {:error, %Ecto.Changeset{}} = Emergencies.update_emergency(emergency, @invalid_attrs)
      assert emergency == Emergencies.get_emergency!(emergency.id)
    end

    test "delete_emergency/1 deletes the emergency" do
      emergency = emergency_fixture()
      assert {:ok, %Emergency{}} = Emergencies.delete_emergency(emergency)
      assert_raise Ecto.NoResultsError, fn -> Emergencies.get_emergency!(emergency.id) end
    end

    test "change_emergency/1 returns a emergency changeset" do
      emergency = emergency_fixture()
      assert %Ecto.Changeset{} = Emergencies.change_emergency(emergency)
    end
  end
end
