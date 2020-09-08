defmodule VisitorTracking.Events.RulesTest do
  use VisitorTracking.DataCase, async: true

  alias VisitorTracking.Events.Rules

  test "create default state" do
    assert {:ok, rule} = Rules.new()
    assert "created" = rule.state
  end

  test "create state from event" do
    event = %{status: "closed"}
    assert rule = Rules.from_event(event)
    assert "closed" == rule.state
  end

  test "error state if event is nil" do
    assert rule = Rules.from_event(nil)
    assert "error" == rule.state
  end

  describe "add a scanner" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :add_scanner)
      assert "created" = rule_after.state
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :add_scanner)
      assert "open" = rule_after.state
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :add_scanner)
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :add_scanner)
    end
  end

  describe "delete an event" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :delete_event)
      assert "created" = rule_after.state
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :delete_event)
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :delete_event)
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :delete_event)
    end
  end

  describe "start an event" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :start_event)
      assert "open" = rule_after.state
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :start_event)
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :start_event)
      assert "open" = rule_after.state
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :start_event)
    end
  end

  describe "close an event" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :close_event)
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :close_event)
      assert "closed" = rule_after.state
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :close_event)
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :close_event)
    end
  end

  describe "archive an event" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :archive_event)
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :archive_event)
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :archive_event)
      assert "archived" = rule_after.state
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :archive_event)
    end
  end

  describe "add a visitor" do
    test "when created" do
      event = %{status: "created"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :add_visitor)
    end

    test "when open" do
      event = %{status: "open"}
      assert rule = Rules.from_event(event)
      assert {:ok, rule_after} = Rules.check(rule, :add_visitor)
      assert "open" = rule_after.state
    end

    test "when closed" do
      event = %{status: "closed"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :add_visitor)
    end

    test "when archived" do
      event = %{status: "archived"}
      assert rule = Rules.from_event(event)
      assert :error = Rules.check(rule, :add_visitor)
    end
  end
end
