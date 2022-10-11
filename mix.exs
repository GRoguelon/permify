defmodule Permify.MixProject do
  use Mix.Project

  def project do
    [
      app: :permify,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      name: "Permify",
      source_url: "https://github.com/GRoguelon/permify",
      homepage_url: "https://www.phoenixframework.org",
      description: "Open-source authorization service and policy engine",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      maintainers: ["Geoffrey Roguelon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/GRoguelon/permify"},
      files: ~w(.formatter.exs lib mix.exs README.md)
    ]
  end

  def docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 2.1", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:jason, "~> 1.4"},
      {:req, "~> 0.3.1"}
    ]
  end
end
