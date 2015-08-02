defmodule Parcelmagic.Mixfile do
  use Mix.Project

  def project do
    [app: :parcelmagic,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Parcelmagic, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :comeonin]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.15"},
     {:phoenix_ecto, "~> 0.8"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 1.4"},
     {:phoenix_live_reload, "~> 0.5", only: :dev},
     {:cowboy, "~> 1.0"},
     {:poison, "~> 1.4.0"},
     {:comeonin, "~> 1.1"},
     {:easypost, git: "https://github.com/Dania02525/easypost-elixir.git"},
     {:plug_jwt, git: "https://github.com/Dania02525/plug_jwt.git"}]
  end
end
