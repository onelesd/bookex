defmodule Bookex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bookex,
      version: "0.0.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bookex.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  # TODO upgrade cowboy and plug to latest versions for http2
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.4.5"},
      {:tesla, "~> 0.10.0"},
      {:meeseeks, "~> 0.7.7"},
      {:jason, "~> 1.0.0"},
      {:cachex, "~> 3.0.0"},
    ]
  end
end
