defmodule VisitorTracking.Events.Rules do
  @moduledoc """
  Event state machine.
  """

  alias __MODULE__

  defstruct state: "created"

  def new, do: {:ok, %Rules{}}

  def from_event(nil), do: %Rules{state: "error"}
  def from_event(event), do: %Rules{state: event.status}

  def check(%Rules{state: "created"} = _rule, :add_scanner),
    do: {:ok, %Rules{state: "created"}}

  def check(%Rules{state: "created"} = _rule, :delete_event),
    do: {:ok, %Rules{state: "created"}}

  def check(%Rules{state: "created"} = _rule, :start_event),
    do: {:ok, %Rules{state: "open"}}

  def check(%Rules{state: "open"} = _rule, :close_event),
    do: {:ok, %Rules{state: "closed"}}

  def check(%Rules{state: "open"} = _rule, :add_scanner),
    do: {:ok, %Rules{state: "open"}}

  def check(%Rules{state: "closed"} = _rule, :archive_event),
    do: {:ok, %Rules{state: "archived"}}

  def check(%Rules{state: "open"} = _rule, :add_visitor),
    do: {:ok, %Rules{state: "open"}}

  def check(_state, _action), do: :error
end
