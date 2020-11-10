defmodule AbsintheSortingCodec.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_sorting_codec,
      version: "1.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Absinthe Sorting Codec",
      description:
        "Codec for generating Absinthe JSON schemas in a deterministic format with alphabetically ordered type definitions",
      package: [
        maintainers: ["Nathan Hadfield"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/hadfieldn/absinthe_sorting_codec"},
        files: ~w(LICENSE README.md lib mix.exs)
      ],
      source_url: "https://github.com/hadfieldn/absinthe_sorting_codec",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe, ">= 1.5.0", only: [:test]},
      {:jason, ">= 1.0.0"},
      {:ex_doc, "~> 0.19", only: [:dev]},
      {:mix_test_watch, "~> 0.8", only: [:test], runtime: false}
    ]
  end
end
