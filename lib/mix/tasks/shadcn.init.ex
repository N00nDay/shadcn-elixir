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
  """
  use Mix.Task

  alias ShadcnElixir.Registry

  @switches [css: :string, js: :string, force: :boolean]

  @impl true
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, switches: @switches)

    css_target = opts[:css] || "assets/css/shadcn.css"
    js_target = opts[:js] || "assets/js/shadcn.js"

    copy(Registry.theme_css(), css_target, opts[:force])
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

      true ->
        File.mkdir_p!(Path.dirname(target))
        File.cp!(src, target)
        Mix.shell().info([:green, "* created ", :reset, target])
    end
  end

  defp app, do: to_string(Mix.Project.config()[:app] || "my_app")
end
