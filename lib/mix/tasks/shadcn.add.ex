defmodule Mix.Tasks.Shadcn.Add do
  @shortdoc "Copy shadcn-elixir component source into your project"
  @moduledoc """
  Copies one or more components (and their dependencies) into your Phoenix project,
  rewriting the module namespace so you own and can customize the source — the shadcn way.

      mix shadcn.add button
      mix shadcn.add dialog dropdown_menu
      mix shadcn.add --all

  Components are written to `lib/<app>_web/components/ui/<name>.ex` as
  `<App>Web.Components.UI.<Name>`. Inter-component references are rewritten to match;
  the lightweight helpers (`ShadcnElixir.cn/1`, `ShadcnElixir.Variants`, `ShadcnElixir.JS`)
  stay as references to the `:shadcn_elixir` dependency.

  ## Options

    * `--all` — add every available component
    * `--namespace Foo.Bar` — target module namespace (default `<App>Web.Components.UI`)
    * `--dir path` — target directory (default `lib/<app>_web/components/ui`)
    * `--force` — overwrite existing files
    * `--list` — print available components and exit
  """
  use Mix.Task

  alias ShadcnElixir.Registry

  @switches [all: :boolean, namespace: :string, dir: :string, force: :boolean, list: :boolean]

  @impl true
  def run(argv) do
    {opts, names, _} = OptionParser.parse(argv, switches: @switches)

    if opts[:list] do
      Mix.shell().info("Available components:\n")
      Registry.list() |> Enum.chunk_every(3) |> Enum.each(&Mix.shell().info("  " <> Enum.join(&1, ", ")))
      :ok
    else
      do_run(opts, names)
    end
  end

  defp do_run(opts, names) do
    requested =
      cond do
        opts[:all] -> Registry.list()
        names == [] -> Mix.raise("Specify component names, or use --all. See `mix shadcn.add --list`.")
        true -> validate(names)
      end

    namespace = opts[:namespace] || default_namespace()
    dir = opts[:dir] || default_dir()
    File.mkdir_p!(dir)

    resolved = Registry.resolve(requested)
    extra = resolved -- Enum.map(requested, &Registry.normalize/1)

    if extra != [] do
      Mix.shell().info("Including dependencies: #{Enum.join(extra, ", ")}")
    end

    written =
      for name <- resolved, reduce: [] do
        acc ->
          target = Path.join(dir, "#{name}.ex")

          cond do
            File.exists?(target) and opts[:force] != true ->
              Mix.shell().info([:yellow, "* skipped ", :reset, Path.relative_to_cwd(target), " (exists; use --force)"])
              acc

            true ->
              File.write!(target, rewrite(Registry.source(name), namespace))
              Mix.shell().info([:green, "* created ", :reset, Path.relative_to_cwd(target)])
              [name | acc]
          end
      end

    print_followup(resolved, namespace)
    {:ok, Enum.reverse(written)}
  end

  defp validate(names) do
    names = Enum.map(names, &Registry.normalize/1)
    unknown = Enum.reject(names, &Registry.exists?/1)

    if unknown != [] do
      Mix.raise("Unknown component(s): #{Enum.join(unknown, ", ")}. See `mix shadcn.add --list`.")
    end

    names
  end

  @doc false
  def rewrite(source, namespace) do
    String.replace(source, "ShadcnElixir.Components.", namespace <> ".")
  end

  defp default_namespace, do: "#{web_module()}.Components.UI"
  defp default_dir, do: Path.join(["lib", "#{app()}_web", "components", "ui"])
  defp app, do: to_string(Mix.Project.config()[:app] || "my_app")
  defp web_module, do: "#{Macro.camelize(app())}Web"

  defp print_followup(resolved, namespace) do
    hooks = resolved |> Enum.flat_map(&Registry.hooks/1) |> Enum.uniq() |> Enum.sort()

    Mix.shell().info("\nDone. Import the components where needed, e.g.:\n")
    Mix.shell().info("    import #{namespace}.Button")

    if hooks != [] do
      Mix.shell().info([
        "\n",
        :bright,
        "JS hooks required: ",
        :reset,
        Enum.join(hooks, ", "),
        "\nRegister them in your app.js (see `mix shadcn.init` output for wiring)."
      ])
    end

    Mix.shell().info("""

    Reminders:
      * Ensure `TwMerge.Cache` is in your application's supervision tree.
      * Ensure the theme is imported in your CSS (see `mix shadcn.init`).
    """)
  end
end
