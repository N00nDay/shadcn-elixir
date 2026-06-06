defmodule DemoWeb.Docs.Examples do
  @moduledoc """
  Live example previews and their source code — a single source of truth.

  Each `examples/<name>.html.heex` partial is:

    * compiled into a function component via `embed_templates/1` (the live **Preview**), and
    * read at compile time into `@sources` (the exact **Code** shown alongside it).

  Because both come from the same file, the preview and the displayed code can never drift.
  """
  use Phoenix.Component
  use ShadcnElixir

  embed_templates "examples/*"

  @examples_path Path.join(__DIR__, "examples")
  @source_files Path.wildcard(Path.join(@examples_path, "*.html.heex"))

  for file <- @source_files do
    @external_resource file
  end

  @sources for file <- @source_files,
               into: %{},
               do:
                 {Path.basename(file, ".html.heex"),
                  file |> File.read!() |> String.trim_trailing()}

  @doc "Raw HEEx source for an example key."
  def source(key), do: Map.fetch!(@sources, key)

  @doc "True when an example partial exists for `key`."
  def exists?(key), do: Map.has_key?(@sources, key)

  @doc "Renders the live preview for an example key."
  def render(key) do
    apply(__MODULE__, String.to_existing_atom(key), [%{}])
  end
end
