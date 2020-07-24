defmodule VisitorTracking.EventsTest do
  use VisitorTracking.DataCase

  alias VisitorTracking.Events

  describe "events" do
    alias VisitorTracking.Events.Event

    @valid_attrs %{
      closed: true,
      date_end: "2010-04-17T14:00:00Z",
      date_start: "2010-04-17T14:00:00Z",
      description: "some description",
      name: "some name",
      status: "some status",
      venue: "some venue"
    }
    @update_attrs %{
      closed: false,
      date_end: "2011-05-18T15:01:01Z",
      date_start: "2011-05-18T15:01:01Z",
      description: "some updated description",
      name: "some updated name",
      status: "some updated status",
      venue: "some updated venue"
    }
    @invalid_attrs %{
      closed: nil,
      date_end: nil,
      date_start: nil,
      description: nil,
      name: nil,
      status: nil,
      venue: nil
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
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.closed == true
      assert event.date_end == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert event.date_start == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert event.description == "some description"
      assert event.name == "some name"
      assert event.status == "some status"
      assert event.venue == "some venue"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.closed == false
      assert event.date_end == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert event.date_start == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert event.description == "some updated description"
      assert event.name == "some updated name"
      assert event.status == "some updated status"
      assert event.venue == "some updated venue"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
