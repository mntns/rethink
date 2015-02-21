defmodule Rethink.Mixfile do
  use Mix.Project

  def project do
    [app: :rethink,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {Rethink, []}]
  end

  defp deps do
    [{:exjsx,  github: "talentdeficit/exjsx"},
     {:socket, github: "meh/elixir-socket"},
     {:inch_ex, only: :docs}]
  end
end
