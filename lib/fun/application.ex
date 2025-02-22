defmodule Fun.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FunWeb.Telemetry,
      Fun.Repo,
      {DNSCluster, query: Application.get_env(:fun, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fun.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Fun.Finch},
      # Start a worker by calling: Fun.Worker.start_link(arg)
      # {Fun.Worker, arg},
      # Start to serve requests, typically the last entry
      FunWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fun.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FunWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
