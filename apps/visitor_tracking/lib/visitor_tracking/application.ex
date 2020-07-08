defmodule VisitorTracking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      VisitorTracking.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: VisitorTracking.PubSub}
      # Start a worker by calling: VisitorTracking.Worker.start_link(arg)
      # {VisitorTracking.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: VisitorTracking.Supervisor)
  end
end
