defmodule DemoWeb.Blocks.Previews do
  @moduledoc """
  Live block previews and their source code — a single source of truth.

  Each `previews/<name>.html.heex` partial is:

    * compiled into a function component via `embed_templates/1` (the live **Preview**), and
    * read at compile time into `@sources` (the exact **Code** shown alongside it).

  Because both come from the same file, the preview and the displayed code can never drift.
  Mirrors `DemoWeb.Docs.Examples`.
  """
  use Phoenix.Component
  use ShadcnElixir

  embed_templates "previews/*"

  @previews_path Path.join(__DIR__, "previews")
  @source_files Path.wildcard(Path.join(@previews_path, "*.html.heex"))

  for file <- @source_files do
    @external_resource file
  end

  # Partial filenames use underscores (valid function names for `embed_templates`), but the
  # registry/block keys are hyphenated ("login-01"), so key the sources by the hyphenated form.
  @sources for file <- @source_files,
               into: %{},
               do:
                 {file |> Path.basename(".html.heex") |> String.replace("_", "-"),
                  file |> File.read!() |> String.trim_trailing()}

  @doc "Raw HEEx source for a block preview key (e.g. \"login-03\")."
  def source(key), do: Map.get(@sources, key, "")

  @doc "True when a preview partial exists for `key`."
  def exists?(key), do: Map.has_key?(@sources, key)

  @doc "Renders the live preview for a block key."
  def render(key) do
    fun = key |> String.replace("-", "_") |> String.to_existing_atom()
    apply(__MODULE__, fun, [%{}])
  end
end
