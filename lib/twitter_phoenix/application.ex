defmodule TwitterPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TwitterPhoenixWeb.Telemetry,
      TwitterPhoenix.Repo,
      {DNSCluster, query: Application.get_env(:twitter_phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TwitterPhoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TwitterPhoenix.Finch},
      # Start a worker by calling: TwitterPhoenix.Worker.start_link(arg)
      # {TwitterPhoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      TwitterPhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwitterPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
