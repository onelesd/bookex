defmodule Bookex.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      {Bookex.API, []},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bookex.Supervisor]
    case Mix.env do
      :dev ->
        watchers =
          Application.get_env(:bookex, Bookex.API.Watcher)[:watchers]
          |> Enum.map(fn {cmd, args} ->
            worker(Bookex.API.Watcher, watcher_args(cmd, args),
              id: {cmd, args}, restart: :transient)
          end)
        Supervisor.start_link(watchers ++ children, opts)
      _    -> Supervisor.start_link(children, opts)
    end
  end

  defp watcher_args(cmd, cmd_args) do
    {args, opts} = Enum.split_while(cmd_args, &is_binary(&1))
    [cmd, args, opts]
  end
end
