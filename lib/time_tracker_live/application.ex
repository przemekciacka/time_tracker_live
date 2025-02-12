defmodule TimeTrackerLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimeTrackerLiveWeb.Telemetry,
      TimeTrackerLive.Repo,
      {DNSCluster, query: Application.get_env(:time_tracker_live, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TimeTrackerLive.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TimeTrackerLive.Finch},
      # Start a worker by calling: TimeTrackerLive.Worker.start_link(arg)
      # {TimeTrackerLive.Worker, arg},
      # Start to serve requests, typically the last entry
      TimeTrackerLiveWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeTrackerLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimeTrackerLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
