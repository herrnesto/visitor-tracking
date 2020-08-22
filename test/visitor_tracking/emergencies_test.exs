defmodule VisitorTracking.EmergenciesTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Emergencies

  describe "emergencies" do
    alias VisitorTracking.Emergencies.Emergency

    test "list_emergencies/0 returns all emergencies" do
      %{id: event_id, organiser: %{id: user_id}} = insert(:event)
      emergency = insert(:emergency, %{event_id: event_id, user_id: user_id})
      assert Emergencies.list_emergencies() == [emergency]
    end

    test "get_emergency_by_event_id!/1 returns the emergency with given id" do
      %{id: event_id, organiser: %{id: user_id}} = insert(:event)
      emergency = insert(:emergency, %{event_id: event_id, user_id: user_id})

      assert Emergencies.get_emergency_by_event_id!(emergency.event_id) == emergency
    end

    test "create_emergency/1 with valid data creates a emergency" do
      assert {:ok, %Emergency{} = emergency} =
               VisitorTracking.Emergencies.create_emergency(%{
                 initiator_id: 2000,
                 event_id: 1000,
                 recipient_email: "some recipient_email",
                 recipient_name: "some recipient_name"
               })

      assert emergency.recipient_email == "some recipient_email"
      assert emergency.recipient_email == "some recipient_email"
      assert emergency.initiator_id == 2000
      assert emergency.event_id == 1000
    end

    test "returns an error if emergency is already assigned" do
      %{id: event_id, organiser: %{id: user_id}} = insert(:event)
      insert(:emergency, %{event_id: event_id, user_id: user_id})

      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                errors: [
                  event_id:
                    {"ALREADY_EXISTS", [constraint: :unique, constraint_name: "emergencies_pkey"]}
                ]
              }} = insert(:emergency, %{event_id: event_id, user_id: user_id})
    end

    test "create_emergency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Emergencies.create_emergency(%{recipient_email: nil, recipient_name: nil})
    end
  end
end
