defmodule Bundestag.MixProject do
  use Mix.Project

  def project do
    [
      app: :bundestag,
      version: "1.0.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Elixir client for the German Bundestag API",
      package: package(),
      source_url: "https://github.com/o2ba/bundestag"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:bypass, "~> 2.1", only: :test, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/o2ba/bundestag"},
      maintainers: ["OBARI Bade"]
    ]
  end
end
