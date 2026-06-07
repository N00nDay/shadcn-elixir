defmodule Mix.Tasks.Shadcn.Init do
  @shortdoc "Set up shadcn-elixir in a Phoenix project"
  @moduledoc """
  One-time setup for shadcn-elixir: copies the theme stylesheet and JS hooks into your
  project and prints the remaining wiring steps.

      mix shadcn.init

  ## Options

    * `--css path` — where to write the theme (default `assets/css/shadcn.css`)
    * `--js path` — where to write the hooks (default `assets/js/shadcn.js`)
    * `--force` — overwrite existing files

  ## Theming

  Pass any of the following to bake a preset into the copied theme (matches the picks in the
  Create customizer). Each appends a token override block:

    * `--base name` — base color: `neutral` (default), `stone`, `zinc`, `mauve`, `olive`, `mist`, `taupe`
    * `--theme name` — accent color, e.g. `blue`, `green`, `rose`, `violet` (one of the preset themes)
    * `--chart name` — chart palette, same names as `--theme`
    * `--radius size` — corner radius: `default` (0.5rem), `none`, `sm`, `md`, `lg`
    * `--menu-accent style` — `subtle` (default) or `bold` (remaps `--accent` to `--primary`, so
      hover/menu surfaces use the accent color)

  Example:

      mix shadcn.init --base stone --theme blue --chart blue --radius lg --menu-accent bold
  """
  use Mix.Task

  alias ShadcnElixir.Registry

  @switches [
    css: :string,
    js: :string,
    force: :boolean,
    base: :string,
    theme: :string,
    chart: :string,
    radius: :string,
    menu_accent: :string
  ]

  # --radius name → CSS value (mirrors the Create customizer's PRESET_RADII).
  @radii %{
    "none" => "0rem",
    "sm" => "0.45rem",
    "md" => "0.625rem",
    "lg" => "0.875rem",
    "default" => "0.5rem"
  }

  @impl true
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, switches: @switches)

    css_target = opts[:css] || "assets/css/shadcn.css"
    js_target = opts[:js] || "assets/js/shadcn.js"

    case copy(Registry.theme_css(), css_target, opts[:force]) do
      :created -> apply_theming(css_target, opts)
      :skipped -> warn_theming_skipped(css_target, opts)
    end

    copy(Registry.js_file(), js_target, opts[:force])

    Mix.shell().info("""

    #{IO.ANSI.bright()}shadcn-elixir setup#{IO.ANSI.reset()}

    1. Supervision tree — add TwMerge.Cache (lib/#{app()}/application.ex):

           children = [
             # ...
             TwMerge.Cache
           ]

    2. CSS (assets/css/app.css) — import Tailwind, then the theme:

           @import "tailwindcss";
           @import "./shadcn.css";

       Tailwind v4 must scan the component files. Add a source line:

           @source "../../lib/#{app()}_web";

    3. JS hooks (assets/js/app.js) — for Select/Command/Combobox/InputOTP/Resizable/Chart/Toaster:

           import { Hooks } from "./shadcn";
           const liveSocket = new LiveSocket("/live", Socket, { hooks: { ...Hooks } });

       (Dead/static views: `import { initShadcn } from "./shadcn"` and call it on load.)

    4. Add components:

           mix shadcn.add button card dialog

    Or use the library modules directly without copying:

           use ShadcnElixir
    """)

    :ok
  end

  defp copy(src, target, force) do
    cond do
      File.exists?(target) and force != true ->
        Mix.shell().info([:yellow, "* skipped ", :reset, target, " (exists; use --force)"])
        :skipped

      true ->
        File.mkdir_p!(Path.dirname(target))
        File.cp!(src, target)
        Mix.shell().info([:green, "* created ", :reset, target])
        :created
    end
  end

  # Bake the requested base color / accent theme / chart palette / radius into the copied
  # theme by appending token-override blocks. Cascade order (later wins) means base must
  # precede theme/chart, and these all follow the default tokens already in the file.
  defp apply_theming(css_target, opts) do
    case theming_blocks(opts) do
      [] ->
        :ok

      blocks ->
        section = "\n/* shadcn-elixir customizer preset */\n" <> Enum.join(blocks, "\n") <> "\n"
        File.write!(css_target, section, [:append])
        Mix.shell().info([:green, "* themed  ", :reset, css_target, " (", preset_summary(opts), ")"])
    end
  end

  defp warn_theming_skipped(css_target, opts) do
    if theming_blocks(opts) != [] do
      Mix.shell().info([
        :yellow,
        "* theming not applied ",
        :reset,
        "(#{css_target} already exists; re-run with --force to regenerate it with the preset)"
      ])
    end
  end

  # Override blocks, in cascade order. `neutral`/`default` are the file's defaults, so they
  # emit nothing. Unknown names are warned and skipped rather than failing the whole setup.
  defp theming_blocks(opts) do
    [{"base", opts[:base]}, {"theme", opts[:theme]}, {"chart", opts[:chart]}]
    |> Enum.flat_map(fn {attr, name} -> preset_block(attr, name) end)
    |> Kernel.++(radius_block(opts[:radius]))
    |> Kernel.++(menu_accent_block(opts[:menu_accent]))
  end

  # "bold" menus reuse the accent color (matches shadcn-svelte: accent := primary). Uses var()
  # so it follows whatever base/theme set --primary to, regardless of block order.
  defp menu_accent_block("bold") do
    [
      ":root{--accent:var(--primary);--accent-foreground:var(--primary-foreground);}",
      ".dark{--accent:var(--primary);--accent-foreground:var(--primary-foreground);}"
    ]
  end

  defp menu_accent_block(name) when name in [nil, "subtle"], do: []

  defp menu_accent_block(name) do
    Mix.shell().info([:yellow, "* unknown --menu-accent ", :reset, name, " (expected: subtle, bold)"])
    []
  end

  defp preset_block(_attr, name) when name in [nil, "neutral"], do: []

  defp preset_block(attr, name) do
    selector = ~s([data-#{attr}="#{name}"])
    lines = preset_lines()
    light = Enum.find(lines, &String.starts_with?(&1, selector <> "{"))
    dark = Enum.find(lines, &String.starts_with?(&1, ".dark " <> selector <> "{"))

    case {light, dark} do
      {nil, nil} ->
        Mix.shell().info([:yellow, "* unknown --#{attr} ", :reset, to_string(name), " (skipped)"])
        []

      _ ->
        [
          light && String.replace_prefix(light, selector, ":root"),
          dark && String.replace_prefix(dark, ".dark " <> selector, ".dark")
        ]
        |> Enum.reject(&is_nil/1)
    end
  end

  defp radius_block(name) when name in [nil, "default"], do: []

  defp radius_block(name) do
    case Map.fetch(@radii, name) do
      {:ok, value} ->
        [":root{--radius:#{value};}"]

      :error ->
        Mix.shell().info([
          :yellow,
          "* unknown --radius ",
          :reset,
          name,
          " (expected one of: #{Enum.join(Map.keys(@radii), ", ")})"
        ])

        []
    end
  end

  defp preset_lines do
    Registry.themes_css() |> File.read!() |> String.split("\n", trim: true)
  end

  defp preset_summary(opts) do
    [
      base: opts[:base],
      theme: opts[:theme],
      chart: opts[:chart],
      radius: opts[:radius],
      "menu-accent": opts[:menu_accent]
    ]
    |> Enum.reject(fn {_k, v} -> v in [nil, "neutral", "default", "subtle"] end)
    |> Enum.map_join(" ", fn {k, v} -> "#{k}=#{v}" end)
  end

  defp app, do: to_string(Mix.Project.config()[:app] || "my_app")
end
