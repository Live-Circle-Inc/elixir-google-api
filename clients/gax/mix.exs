defmodule EgaGax.MixProject do
  use Mix.Project

  # Forked from google_gax 0.4.1. Upstream (GoogleCloudPlatform/elixir-google-api)
  # was formally archived, so this fork carries the fixes upstream can no longer
  # take. Minor bumped to signal a behaviour fix over 0.4.1.
  @version "0.5.0"

  @source_url "https://github.com/Live-Circle-Inc/ega/tree/main/clients/gax"

  def project do
    [
      app: :ega_gax,
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      elixirc_paths: paths(Mix.env()),
      # consolidate_protocols: Mix.env != :test,
      source_url: @source_url
    ]
  end

  def application() do
    [extra_applications: [:logger]]
  end

  defp deps() do
    [
      {:tesla, "~> 1.2"},
      # Upstream capped this at "< 5.0.0". poison 5 dropped Poison.Decode.decode/2,
      # but this library only ever needs Poison.Decode.transform/2 (see
      # GoogleApi.Gax.ModelBase.poison_transform/2, which already branches on
      # function_exported?/3), plus Poison.Encoder.encode/2, the Poison.Decoder
      # protocol and Poison.decode/2's :as option - all of which still exist in
      # poison 6. The cap was conservative, not a real incompatibility.
      {:poison, ">= 3.0.0 and < 7.0.0"},
      {:ex_doc, "~> 0.16", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  # NOTE: upstream also declared {:mime, "~> 1.0"}. It is dropped here because
  # nothing in lib/ references MIME - the requirement did nothing except hold
  # every dependent's mime at 1.x, two majors behind.

  defp description() do
    """
    Google API Extensions for Elixir - maintained drop-in fork of google_gax
    (archived upstream). Shared runtime for the generated GoogleApi.* client
    libraries. Fixes Tesla >= 1.18.3 compatibility.
    """
  end

  defp package() do
    [
      name: "ega_gax",
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Live Circle"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Upstream (archived)" =>
          "https://github.com/GoogleCloudPlatform/elixir-google-api/tree/master/clients/gax"
      }
    ]
  end

  defp paths(:test), do: ["lib", "test/test_client"]

  defp paths(_), do: ["lib"]
end
