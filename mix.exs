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
    [applications: [:logger, :termsize]]
  end

  defp deps do
    [
      {:earmark, "~> 1.0", only: :dev},
      {:exchalk, "~> 1.0.2" },
      {:ex_doc, "~> 0.14", only: :dev},
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
