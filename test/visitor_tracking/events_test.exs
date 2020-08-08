defmodule VisitorTracking.EventsTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.{Events, Events.Event, Events.Visitor}

  @valid_attrs %{
    closed: true,
    date_start: ~N[2011-05-18T15:01:01Z],
    visitor_limit: 10,
    name: "some name",
    status: "some status",
    venue: "some venue",
    organiser_id: 3
  }
  @update_attrs %{
    closed: false,
    date_start: ~N[2011-05-18T15:01:01Z],
    visitor_limit: 10,
    name: "some updated name",
    status: "some updated status",
    venue: "some updated venue",
    organiser_id: 3
  }
  @invalid_attrs %{
    closed: nil,
    date_start: nil,
    visitor_limit: nil,
    name: nil,
    status: nil,
    venue: nil,
    organiser_id: nil
  }

  test "list_events/1 returns all events for an organiser" do
    user = insert(:user)
    %{id: event_id, organiser_id: organiser_id} = insert(:event, organiser: user)
    assert [%Events.Event{id: ^event_id}] = Events.list_events(organiser_id)
  end

  test "get_event!/1 returns the event with given id" do
    %{id: event_id, organiser_id: organiser_id} = insert(:event)
    assert %Events.Event{id: ^event_id} = Events.get_event!(event_id, organiser_id)
  end

  describe "create_event/1" do
    test "with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.closed == true
      assert event.date_start == ~N[2011-05-18T15:01:01Z]
      assert event.visitor_limit == 10
      assert event.name == "some name"
      assert event.status == "some status"
      assert event.venue == "some venue"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end
  end

  describe "update_event/2" do
    test "update_event/2 with valid data updates the event" do
      event = insert(:event)
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.closed == false
      assert event.date_start == ~N[2011-05-18T15:01:01Z]
      assert event.visitor_limit == 10
      assert event.name == "some updated name"
      assert event.status == "some updated status"
      assert event.venue == "some updated venue"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = insert(:event)
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
    end
  end

  test "delete_event/1 deletes the event" do
    event = insert(:event)
    assert {:ok, %Event{}} = Events.delete_event(event)
    assert nil == Events.get_event(event.id)
  end

  test "change_event/1 returns a event changeset" do
    event = insert(:event)
    assert %Ecto.Changeset{} = Events.change_event(event)
  end

  describe "list_scanners/1" do
    test "returns an empty list if no scanners exist for an event" do
      event = insert(:event)
      assert [] == Events.list_scanners(event.id)
    end
  end

  describe "add_scanner/2" do
    test "returns an error if the user does not exist" do
      event = insert(:event)
      assert {:error, "User does not exist"} == Events.add_scanner(event.id, "+41000000000")
    end

    test "returns an {:ok, scanner} if the user exists" do
      event = insert(:event)
      %{phone: phone} = insert(:user)
      assert {:ok, _} = Events.add_scanner(event.id, phone)
    end
  end

  test "get_event_with_prelaods/1 returns an event with the organiser preloaded" do
    user = insert(:user, phone_verified: true, email_verified: true)
    event = insert(:event, organiser: user)
    assert %{organiser: %{email: _}} = Events.get_event_with_preloads(event.id)
  end

  test "assign_organiser/2 assigns an organiser to an event" do
    user = insert(:user, phone_verified: true, email_verified: true)
    event = insert(:event, organiser: nil)
    assert {:ok, %Events.Event{}} = Events.assign_organiser(event, user)
  end

  describe "assign_visitor/2" do
    test "assigns a visitor to an event" do
      %{id: event_id} = event = insert(:event)
      %{id: user_id} = user = insert(:user)

      assert {:ok, %Visitor{user_id: ^user_id, event_id: ^event_id}} =
               Events.assign_visitor(event, user)
    end

    test "returns an error if visitor is already assigned" do
      event = insert(:event)
      user = insert(:user)
      Events.assign_visitor(event, user)

      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                errors: [
                  event_id:
                    {"ALREADY_EXISTS",
                     [constraint: :unique, constraint_name: "events_visitors_pkey"]}
                ]
              }} = Events.assign_visitor(event, user)
    end
  end
end
