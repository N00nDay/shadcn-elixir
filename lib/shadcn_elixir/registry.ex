defmodule ShadcnElixir.Registry do
  @moduledoc """
  Component registry for the `mix shadcn.*` generators.

  Rather than maintaining a hand-written manifest, the registry derives everything from
  the component source files themselves: inter-component dependencies are discovered by
  scanning for `ShadcnElixir.Components.*` references, and required JS hooks by scanning
  for `phx-hook="Shadcn*"`.
  """

  @doc "Absolute path to the shadcn_elixir checkout (the dep, or this repo in dev)."
  def root_path do
    case Mix.Project.deps_paths()[:shadcn_elixir] do
      nil -> File.cwd!()
      path -> path
    end
  rescue
    _ -> File.cwd!()
  end

  @doc "Directory containing the canonical component source files."
  def components_dir, do: Path.join(root_path(), "lib/shadcn_elixir/components")

  @doc "Path to the theme stylesheet."
  def theme_css, do: Path.join(root_path(), "priv/static/theme.css")

  @doc "Path to the theme presets (base color / accent theme / chart color palettes)."
  def themes_css, do: Path.join(root_path(), "priv/static/themes.css")

  @doc "Path to the JS hooks file."
  def js_file, do: Path.join(root_path(), "assets/js/shadcn_elixir.js")

  @doc "List all available component names (snake_case)."
  def list do
    components_dir()
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.map(&Path.rootname/1)
    |> Enum.sort()
  end

  @doc "Returns `true` if the named component exists."
  def exists?(name), do: name in list()

  @doc "Absolute path to a component's source file."
  def path(name), do: Path.join(components_dir(), "#{name}.ex")

  @doc "Read a component's source."
  def source(name), do: File.read!(path(name))

  @doc "The module suffix for a component, e.g. `\"alert_dialog\"` -> `\"AlertDialog\"`."
  def module_suffix(name), do: Macro.camelize(name)

  @doc """
  Direct sibling-component dependencies of `name`, discovered from its source.
  """
  def deps(name) do
    ~r/ShadcnElixir\.Components\.([A-Z][A-Za-z0-9]+)/
    |> Regex.scan(source(name))
    |> Enum.map(fn [_, mod] -> Macro.underscore(mod) end)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == name))
    |> Enum.filter(&exists?/1)
  end

  @doc """
  Fully resolve a list of component names to include all transitive dependencies.
  Returns a sorted, de-duplicated list.
  """
  def resolve(names) when is_list(names) do
    names
    |> Enum.map(&normalize/1)
    |> resolve(MapSet.new())
    |> MapSet.to_list()
    |> Enum.sort()
  end

  defp resolve([], acc), do: acc

  defp resolve([name | rest], acc) do
    if MapSet.member?(acc, name) or not exists?(name) do
      resolve(rest, acc)
    else
      acc = MapSet.put(acc, name)
      resolve(deps(name) ++ rest, acc)
    end
  end

  @doc "JS hook names a component requires (e.g. `[\"ShadcnSelect\"]`)."
  def hooks(name) do
    ~r/phx-hook="(Shadcn[A-Za-z]+)"/
    |> Regex.scan(source(name))
    |> Enum.map(fn [_, hook] -> hook end)
    |> Enum.uniq()
  end

  @doc "Normalize a user-supplied component name (accepts kebab or snake case)."
  def normalize(name), do: name |> to_string() |> String.replace("-", "_")
end
