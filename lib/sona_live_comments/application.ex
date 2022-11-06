defmodule SonaLiveComments.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SonaLiveCommentsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SonaLiveComments.PubSub},
      # Start the Endpoint (http/https)
      SonaLiveCommentsWeb.Endpoint,
      # Start post repository
      SonaLiveComments.PostRepository,
      # Start comment repository
      SonaLiveComments.CommentRepository,
      # Presence to follow comments
      pg_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SonaLiveComments.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SonaLiveCommentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # default scope for pg
  defp pg_spec do
    %{
      id: :pg,
      start: {:pg, :start_link, []}
    }
  end
end
