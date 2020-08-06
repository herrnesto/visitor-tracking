defmodule VisitorTracking.EventsTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Events
  alias VisitorTracking.Events.Event

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

  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Events.create_event()

    event
  end

  test "list_events/0 returns all events" do
    event = event_fixture()
    assert Events.list_events(3) == [event]
  end

  test "get_event!/1 returns the event with given id" do
    event = event_fixture()
    assert Events.get_event!(event.id, 3) == event
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
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.closed == false
      assert event.date_start == ~N[2011-05-18T15:01:01Z]
      assert event.visitor_limit == 10
      assert event.name == "some updated name"
      assert event.status == "some updated status"
      assert event.venue == "some updated venue"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id, 3)
    end
  end

  test "delete_event/1 deletes the event" do
    event = event_fixture()
    assert {:ok, %Event{}} = Events.delete_event(event)
    assert nil == Events.get_event(event.id)
  end

  test "change_event/1 returns a event changeset" do
    event = event_fixture()
    assert %Ecto.Changeset{} = Events.change_event(event)
  end
end
