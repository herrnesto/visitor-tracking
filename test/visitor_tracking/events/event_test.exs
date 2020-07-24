defmodule VisitorTracking.Events.EventTest do
  use ExUnit.Case

  alias Ecto.Changeset
  alias VisitorTracking.Events.Event
  alias VisitorTracking.Factory

  describe "changeset/1" do
    test "success: returns a valid changeset when given valid arguments" do
      user = Factory.user_factory()

      {:ok, datetime, _} = DateTime.from_iso8601("2030-06-23T23:50:07Z")

      params = %{
        organiser: user,
        name: "Dancing Corona",
        venue: "City Beach, Hawai",
        description: "blabla",
        date_start: datetime,
        date_end: datetime
      }

      changeset = Event.changeset(%Event{}, params)

      assert %Changeset{valid?: true, changes: changes} = changeset
    end
  end
end
