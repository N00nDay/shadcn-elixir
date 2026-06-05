defmodule ShadcnElixir.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/craighowell/shadcn-elixir"

  def project do
    [
      app: :shadcn_elixir,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "ShadcnElixir",
      source_url: @source_url,
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:tw_merge, "~> 0.1"},
      # dev/test only
      {:phoenix_storybook, "~> 0.8", only: :dev},
      {:floki, ">= 0.30.0", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A portable Phoenix/Elixir component library — a faithful port of shadcn/ui. " <>
      "Every component, matching UI, with CSS-variable theming and copy-paste ownership."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib priv assets/js .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
