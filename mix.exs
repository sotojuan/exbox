defmodule ExBox.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exbox,
      version: "0.0.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description,
      package: package,
      deps: deps
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:exchalk, "~> 1.0.0" },
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:termsize, "~> 1.0.0" }
    ]
  end

  defp description do
    """
    Cool text and CLI boxes
    """
  end

  defp package do
    [
      maintainers: ["sotojuan"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sotojuan/exbox"}
    ]
  end
end
