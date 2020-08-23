defmodule VisitorTracking.EventsTest do
  use VisitorTracking.DataCase, async: true

  alias VisitorTracking.{Accounts, Events, Events.Event, Events.Visitor}

  setup do
    user = insert(:user, email_verified: true, phone_verified: true)
    event = insert(:event)
    insert(:scanner, event_id: event.id, user_id: user.id)

    {:ok, %{event: event, user: user}}
  end

  @valid_attrs %{
    "closed" => "true",
    "date_start" => ~N[2011-05-18T15:01:01Z],
    "visitor_limit" => 10,
    "name" => "some name",
    "status" => "created",
    "venue" => "some venue",
    "organiser_id" => "3"
  }
  @update_attrs %{
    "closed" => "false",
    "date_start" => ~N[2011-05-18T15:01:01Z],
    "visitor_limit" => 10,
    "name" => "some updated name",
    "status" => "some updated status",
    "venue" => "some updated venue",
    "organiser_id" => "3"
  }
  @invalid_attrs %{
    "closed" => nil,
    "date_start" => nil,
    "visitor_limit" => nil,
    "name" => nil,
    "status" => nil,
    "venue" => nil,
    "organiser_id" => nil
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
      user = insert(:user, email_verified: true, phone_verified: true)
      data = Map.put(@valid_attrs, "organiser_id", user.id)

      assert {:ok, event} = Events.create_event(data)

      assert event.date_start == ~N[2011-05-18T15:01:01Z]
      assert event.visitor_limit == 10
      assert event.name == "some name"
      assert event.status == "created"
      assert event.venue == "some venue"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "add organiser as scanner" do
      user = insert(:user, email_verified: true, phone_verified: true)

      assert {:ok, event} = Events.create_event(Map.put(@valid_attrs, "organiser_id", user.id))

      %{scanners: scanners} = Events.get_event_with_preloads(event.id)
      result = Enum.any?(scanners, fn %{id: id} -> id == user.id end)
      assert true = result
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

  test "get_event_with_preloads/1 returns an event with the organiser and scanners preloaded" do
    user = insert(:user, phone_verified: true, email_verified: true)
    event = insert(:event, organiser: user)
    insert(:scanner, event_id: event.id)
    insert(:scanner, event_id: event.id)

    assert %{organiser: %{email: _}, scanners: scanners} =
             Events.get_event_with_preloads(event.id)

    assert length(scanners) == 2
  end

  test "assign_organiser/2 assigns an organiser to an event" do
    user = insert(:user, phone_verified: true, email_verified: true)
    event = insert(:event, organiser: nil)
    assert {:ok, %Events.Event{}} = Events.assign_organiser(event, user)
  end

  describe "assign_visitor/2" do
    test "assigns a visitor to an event" do
      %{id: event_id} = event = insert(:event, status: "open")
      %{id: user_id} = user = insert(:user)

      assert {:ok, %Visitor{user_id: ^user_id, event_id: ^event_id}} =
               Events.assign_visitor(event, user)
    end

    test "returns an error if visitor is already assigned" do
      event = insert(:event, status: "open")
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

    test "returns an error if the event is closed" do
      event = insert(:event, status: "closed")
      user = insert(:user)

      assert {:error, :event_closed} = Events.assign_visitor(event, user)
    end
  end

  describe "count_visitors/1" do
    test "starting a new event, visitors are 0" do
      event = insert(:event)
      assert 0 == Events.count_visitors(event.id)
    end

    test "returns a number when the id is an integer" do
      event = insert(:event, status: "open")
      user = insert(:user)
      Events.assign_visitor(event, user)

      assert 1 == Events.count_visitors(event.id)
    end

    test "returns a number when the id is a string" do
      event = insert(:event, status: "open")
      user = insert(:user)
      Events.assign_visitor(event, user)

      assert 1 == Events.count_visitors("#{event.id}")
    end
  end

  describe "insert_action/1" do
    test "inserts an action for a user" do
      event = insert(:event)
      %{uuid: uuid} = insert(:user)

      assert {:ok, %{action: "in"}} =
               Events.insert_action(%{
                 "event_id" => "#{event.id}",
                 "uuid" => "#{uuid}",
                 "action" => "in"
               })
    end
  end

  describe "get_visitors_stats/1" do
    test "get stats about user at an event" do
      event = insert(:event)
      user_1 = insert(:user)
      user_2 = insert(:user)
      user_3 = insert(:user)
      user_4 = insert(:user)

      assert %{total_visitors: 0, active_visitors: 0} = Events.get_visitors_stats(event.id)

      insert(:visitor_action, %{event_id: event.id, user_id: user_1.id, action: "in"})
      assert %{total_visitors: 1, active_visitors: 1} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_1.id, action: "out"})
      assert %{total_visitors: 1, active_visitors: 0} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_1.id, action: "in"})
      assert %{total_visitors: 1, active_visitors: 1} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_2.id, action: "in"})
      assert %{total_visitors: 2, active_visitors: 2} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_3.id, action: "in"})
      assert %{total_visitors: 3, active_visitors: 3} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_2.id, action: "out"})
      assert %{total_visitors: 3, active_visitors: 2} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_3.id, action: "out"})
      assert %{total_visitors: 3, active_visitors: 1} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_4.id, action: "in"})
      assert %{total_visitors: 4, active_visitors: 2} = Events.get_visitors_stats(event.id)
      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event.id, user_id: user_2.id, action: "in"})
      assert %{total_visitors: 4, active_visitors: 3} = Events.get_visitors_stats(event.id)
    end

    test "event does not exists" do
      assert %{total_visitors: 0, active_visitors: 0} =
               Events.get_visitors_stats(999_999_999_999_999)
    end
  end

  describe "get_visitor_last_action/2" do
    test "returns last action" do
      %{id: event_id} = insert(:event)
      %{id: user_id} = insert(:user)

      insert(:visitor_action, %{event_id: event_id, user_id: user_id, action: "in"})

      assert "in" = Events.get_visitor_last_action(user_id, event_id)

      :timer.sleep(1000)

      insert(:visitor_action, %{event_id: event_id, user_id: user_id, action: "out"})

      assert "out" = Events.get_visitor_last_action(user_id, event_id)
    end

    test "returns last action if no action is there" do
      %{id: event_id} = insert(:event)
      %{id: user_id} = insert(:user)

      assert "out" = Events.get_visitor_last_action(user_id, event_id)
    end
  end

  describe "get_all_visitors_by_event/2" do
    test "returns a list of users" do
      organiser = insert(:user, phone_verified: true, email_verified: true)
      event = insert(:event, organiser: organiser)

      user_1 = insert(:user)
      user_2 = insert(:user)
      user_3 = insert(:user)

      insert(:visitor_action, %{event_id: event.id, user_id: user_1.id, action: "in"})
      insert(:visitor_action, %{event_id: event.id, user_id: user_2.id, action: "in"})
      insert(:visitor_action, %{event_id: event.id, user_id: user_3.id, action: "in"})

      assert [%Accounts.User{}, %Accounts.User{}, %Accounts.User{}] =
               Events.get_all_visitors_by_event(event.id)
    end

    test "returns no user" do
      organiser = insert(:user, phone_verified: true, email_verified: true)
      event = insert(:event, organiser: organiser)

      assert [] = Events.get_all_visitors_by_event(event.id)
      assert true = Enum.empty?(Events.get_all_visitors_by_event(event.id))
    end

    test "send invalid event_id" do
      event_id = 99999
      assert [] = Events.get_all_visitors_by_event(event.id)
      assert true = Enum.empty?(Events.get_all_visitors_by_event(event.id))
    end
  end
end
