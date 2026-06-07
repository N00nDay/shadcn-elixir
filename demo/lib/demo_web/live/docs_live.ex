defmodule DemoWeb.DocsLive do
  @moduledoc """
  Getting-started documentation pages (`/docs/:page`): Introduction, Installation,
  Theming, and Dark Mode. Content is adapted from the project README.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents
  alias DemoWeb.Docs

  @pages ~w(introduction installation theming dark-mode)

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(params, _uri, socket) do
    page = params["page"] || "introduction"
    page = if page in @pages, do: page, else: "introduction"

    {:noreply, assign(socket, page: page, page_title: Docs.page_title(page), toc: toc_for(page))}
  end

  defp toc_for("introduction") do
    [
      %{id: "coming-from", label: "Coming from React or Svelte?"},
      %{id: "credits", label: "Credits"}
    ]
  end

  defp toc_for("installation") do
    [
      %{id: "add-dependency", label: "Add the dependency"},
      %{id: "tw-merge-cache", label: "Start the tw_merge cache"},
      %{id: "import-components", label: "Import the components"},
      %{id: "scan-tailwind", label: "Scan the markup"}
    ]
  end

  defp toc_for("theming") do
    [
      %{id: "convention", label: "Convention"},
      %{id: "default-theme", label: "Default theme"},
      %{id: "add-colors", label: "Adding new colors"},
      %{id: "base-colors", label: "Base color themes"}
    ]
  end

  defp toc_for(_), do: []

  def render(assigns) do
    ~H"""
    <.docs_shell
      active={{:page, @page}}
      toc={@toc}
      breadcrumb={[
        %{label: "Docs", href: "/docs/introduction"},
        %{label: Docs.page_title(@page), href: nil}
      ]}
    >
      <.page_content page={@page} />
    </.docs_shell>
    """
  end

  attr :page, :string, required: true

  defp page_content(%{page: "introduction"} = assigns) do
    ~H"""
    <.doc_heading
      title="Introduction"
      description="A portable Phoenix/Elixir component library — a faithful port of shadcn/ui."
    />
    <div class="space-y-4 text-sm leading-7 text-muted-foreground">
      <p>
        Every component, matching UI, with the same extensibility model: CSS-variable theming
        and <span class="font-medium text-foreground">copy-paste ownership</span>. Built on
        Phoenix function components,
        <code class="rounded bg-muted px-1 py-0.5 text-xs">Phoenix.LiveView.JS</code>
        + colocated hooks for interactivity, and Tailwind CSS v4.
      </p>
      <p>shadcn-elixir gives you two ways to work:</p>
    </div>
    <div class="mt-6 grid gap-4 sm:grid-cols-2">
      <.card>
        <.card_header>
          <.card_title>Use as a dependency</.card_title>
          <.card_description>The quickest start — add the Hex package and import.</.card_description>
        </.card_header>
        <.card_footer>
          <.button variant="outline" navigate="/docs/installation">Installation</.button>
        </.card_footer>
      </.card>
      <.card>
        <.card_header>
          <.card_title>Own the source</.card_title>
          <.card_description>
            Generate components into your app with <code class="text-xs">mix shadcn.add</code>
            and customize freely.
          </.card_description>
        </.card_header>
        <.card_footer>
          <.button variant="outline" navigate="/docs/components/button">Browse components</.button>
        </.card_footer>
      </.card>
    </div>

    <.doc_section_title id="coming-from">Coming from React or Svelte?</.doc_section_title>
    <p class="text-sm leading-7 text-muted-foreground">
      The component names, anatomy, and examples mirror
      <.link
        href="https://ui.shadcn.com"
        target="_blank"
        rel="noreferrer"
        class="underline underline-offset-4"
      >
        shadcn/ui
      </.link>
      (React) and <.link
        href="https://www.shadcn-svelte.com"
        target="_blank"
        rel="noreferrer"
        class="underline underline-offset-4"
      >shadcn-svelte</.link>.
      A <code class="rounded bg-muted px-1 py-0.5 text-xs">&lt;Dialog&gt;</code>
      with a <code class="rounded bg-muted px-1 py-0.5 text-xs">DialogTrigger</code>
      and <code class="rounded bg-muted px-1 py-0.5 text-xs">DialogContent</code>
      becomes <code class="rounded bg-muted px-1 py-0.5 text-xs">&lt;.dialog&gt;</code>
      with <code class="rounded bg-muted px-1 py-0.5 text-xs">&lt;.dialog_trigger&gt;</code>
      and <code class="rounded bg-muted px-1 py-0.5 text-xs">&lt;.dialog_content&gt;</code>
      — composed sub-components become snake_cased function components, props become HEEx attributes,
      and the same Tailwind tokens drive theming.
    </p>

    <.doc_section_title id="credits">Credits</.doc_section_title>
    <p class="text-sm leading-7 text-muted-foreground">
      shadcn-elixir is an independent port of <.link
        href="https://ui.shadcn.com"
        target="_blank"
        rel="noreferrer"
        class="underline underline-offset-4"
      >shadcn/ui</.link>,
      created by <.link
        href="https://twitter.com/shadcn"
        target="_blank"
        rel="noreferrer"
        class="underline underline-offset-4"
      >shadcn</.link>.
      All credit for the original design system and component API belongs to its author. This project
      simply brings that work to the Phoenix ecosystem, following the example set by <.link
        href="https://www.shadcn-svelte.com"
        target="_blank"
        rel="noreferrer"
        class="underline underline-offset-4"
      >shadcn-svelte</.link>.
      Both shadcn/ui and shadcn-elixir are MIT licensed.
    </p>
    """
  end

  defp page_content(%{page: "installation"} = assigns) do
    ~H"""
    <.doc_heading title="Installation" description="Add shadcn-elixir to your Phoenix app." />

    <.doc_section_title id="add-dependency">1. Add the dependency</.doc_section_title>
    <.code_block id="install-deps" language="elixir" source={deps_snippet()} />

    <.doc_section_title id="tw-merge-cache">2. Start the tw_merge cache</.doc_section_title>
    <p class="mb-4 text-sm text-muted-foreground">
      <code class="rounded bg-muted px-1 py-0.5 text-xs">cn/1</code>
      uses <code class="rounded bg-muted px-1 py-0.5 text-xs">tw_merge</code>, which needs a cache
      process. Add it to your application's supervision tree.
    </p>
    <.code_block id="install-cache" language="elixir" source={cache_snippet()} />

    <.doc_section_title id="import-components">3. Import the components</.doc_section_title>
    <p class="mb-4 text-sm text-muted-foreground">
      Add <code class="rounded bg-muted px-1 py-0.5 text-xs">use ShadcnElixir</code>
      to your web module's <code class="text-xs">html_helpers</code>, or import a single module.
    </p>
    <.code_block id="install-use" language="elixir" source={use_snippet()} />

    <.doc_section_title id="scan-tailwind">4. Scan the markup with Tailwind</.doc_section_title>
    <.code_block
      id="install-source"
      language="elixir"
      source={~S|@source "../../deps/shadcn_elixir/lib";|}
    />
    """
  end

  defp page_content(%{page: "theming"} = assigns) do
    ~H"""
    <.doc_heading
      title="Theming"
      description="shadcn-elixir uses CSS variables for color tokens, just like shadcn/ui."
    />
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      Import the theme after Tailwind in your app's CSS
      (<code class="rounded bg-muted px-1 py-0.5 text-xs">assets/css/app.css</code>):
    </p>
    <.code_block id="theming-import" language="elixir" source={theming_snippet()} />

    <.doc_section_title id="convention">Convention</.doc_section_title>
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      Tokens follow shadcn's <code class="text-xs">background</code>/<code class="text-xs">foreground</code> convention:
      <code class="text-xs">--primary</code>
      is a surface color and <code class="text-xs">--primary-foreground</code>
      is the text/icon color used on top of it. Each
      token is exposed as a Tailwind utility (<code class="text-xs">bg-primary</code>, <code class="text-xs">text-primary-foreground</code>) via the
      <code class="text-xs">@theme inline</code>
      block in <code class="text-xs">theme.css</code>, which maps
      every <code class="text-xs">--token</code>
      to a <code class="text-xs">--color-*</code>
      entry.
    </p>

    <.doc_section_title id="default-theme">Default theme</.doc_section_title>
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      These are every variable shadcn-elixir ships with today — the <strong>Neutral</strong>
      base — for
      light (<code class="text-xs">:root</code>) and dark (<code class="text-xs">.dark</code>) modes.
      Override any of them in your own CSS after the import to re-theme.
    </p>
    <.code_block id="theme-default" language="css" source={base_theme_neutral()} />

    <.doc_section_title id="add-colors">Adding new colors</.doc_section_title>
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      Define the value for both modes, then register it in <code class="text-xs">@theme inline</code>
      so Tailwind generates the utilities. For example, a <code class="text-xs">warning</code>
      color:
    </p>
    <.code_block id="theme-add-colors" language="css" source={add_colors_snippet()} />
    <p class="mt-6 text-sm leading-7 text-muted-foreground">
      Now <code class="text-xs">bg-warning</code>
      and <code class="text-xs">text-warning-foreground</code>
      work like any built-in token, flipping automatically in dark mode.
    </p>

    <.doc_section_title id="base-colors">Base color themes</.doc_section_title>
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      Prefer a different gray? Copy one of the bases below over your
      <code class="text-xs">:root</code>
      and <code class="text-xs">.dark</code>
      blocks to swap the light and
      dark theme. (The chart and radius tokens are identical across all of them.)
    </p>
    <.tabs id="theme-bases">
      <.tabs_list class="mb-4">
        <.tabs_trigger tabs="theme-bases" value="neutral" active>Neutral</.tabs_trigger>
        <.tabs_trigger tabs="theme-bases" value="stone">Stone</.tabs_trigger>
        <.tabs_trigger tabs="theme-bases" value="zinc">Zinc</.tabs_trigger>
        <.tabs_trigger tabs="theme-bases" value="gray">Gray</.tabs_trigger>
        <.tabs_trigger tabs="theme-bases" value="slate">Slate</.tabs_trigger>
      </.tabs_list>
      <.tabs_content tabs="theme-bases" value="neutral" active>
        <.code_block id="theme-base-neutral" language="css" source={base_theme_neutral()} />
      </.tabs_content>
      <.tabs_content tabs="theme-bases" value="stone">
        <.code_block id="theme-base-stone" language="css" source={base_theme_stone()} />
      </.tabs_content>
      <.tabs_content tabs="theme-bases" value="zinc">
        <.code_block id="theme-base-zinc" language="css" source={base_theme_zinc()} />
      </.tabs_content>
      <.tabs_content tabs="theme-bases" value="gray">
        <.code_block id="theme-base-gray" language="css" source={base_theme_gray()} />
      </.tabs_content>
      <.tabs_content tabs="theme-bases" value="slate">
        <.code_block id="theme-base-slate" language="css" source={base_theme_slate()} />
      </.tabs_content>
    </.tabs>
    """
  end

  defp page_content(%{page: "dark-mode"} = assigns) do
    ~H"""
    <.doc_heading
      title="Dark Mode"
      description="Dark mode is driven by a `.dark` class on the <html> element."
    />
    <p class="mb-4 text-sm leading-7 text-muted-foreground">
      Toggle the class and persist the choice in <code class="text-xs">localStorage</code>. This
      demo does exactly that — try the toggle in the top-right.
    </p>
    <.code_block id="dark-mode-js" language="elixir" source={dark_mode_snippet()} />
    <p class="mt-6 text-sm leading-7 text-muted-foreground">
      Because every component reads semantic tokens (which flip under <code class="text-xs">.dark</code>), no per-component changes are needed.
    </p>
    """
  end

  defp deps_snippet do
    ~S'''
    def deps do
      [
        {:shadcn_elixir, "~> 0.1.0"}
      ]
    end
    '''
    |> String.trim_trailing()
  end

  defp cache_snippet do
    ~S'''
    children = [
      # ...
      TwMerge.Cache
    ]
    '''
    |> String.trim_trailing()
  end

  defp use_snippet do
    ~S'''
    use ShadcnElixir
    # or
    import ShadcnElixir.Components.Button
    '''
    |> String.trim_trailing()
  end

  defp theming_snippet do
    ~S'''
    @import "tailwindcss";
    @import "../../deps/shadcn_elixir/priv/static/theme.css";
    '''
    |> String.trim_trailing()
  end

  defp dark_mode_snippet do
    ~S'''
    const stored = localStorage.getItem("theme");
    if (stored === "dark") document.documentElement.classList.add("dark");

    window.toggleTheme = () => {
      const el = document.documentElement;
      el.classList.toggle("dark");
      localStorage.setItem("theme", el.classList.contains("dark") ? "dark" : "light");
    };
    '''
    |> String.trim_trailing()
  end

  # Chart + radius tokens are identical across every base color, so they live here once.
  @light_charts """
    --chart-1: oklch(0.646 0.222 41.116);
    --chart-2: oklch(0.6 0.118 184.704);
    --chart-3: oklch(0.398 0.07 227.392);
    --chart-4: oklch(0.828 0.189 84.429);
    --chart-5: oklch(0.769 0.188 70.08);
  """

  @dark_charts """
    --chart-1: oklch(0.488 0.243 264.376);
    --chart-2: oklch(0.696 0.17 162.48);
    --chart-3: oklch(0.769 0.188 70.08);
    --chart-4: oklch(0.627 0.265 303.9);
    --chart-5: oklch(0.645 0.246 16.439);
  """

  defp theme_css(light, dark) do
    ":root {\n  --radius: 0.625rem;\n" <>
      light <> @light_charts <> "}\n\n.dark {\n" <> dark <> @dark_charts <> "}"
  end

  defp add_colors_snippet do
    """
    /* 1. Define the token for light and dark. */
    :root {
      --warning: oklch(0.84 0.16 84);
      --warning-foreground: oklch(0.28 0.07 46);
    }

    .dark {
      --warning: oklch(0.48 0.1 84);
      --warning-foreground: oklch(0.98 0.02 84);
    }

    /* 2. Register it so Tailwind generates the utilities. */
    @theme inline {
      --color-warning: var(--warning);
      --color-warning-foreground: var(--warning-foreground);
    }

    /* 3. Use it anywhere: <div class="bg-warning text-warning-foreground"> */
    """
    |> String.trim()
  end

  defp base_theme_neutral, do: theme_css(neutral_light(), neutral_dark())
  defp base_theme_stone, do: theme_css(stone_light(), stone_dark())
  defp base_theme_zinc, do: theme_css(zinc_light(), zinc_dark())
  defp base_theme_gray, do: theme_css(gray_light(), gray_dark())
  defp base_theme_slate, do: theme_css(slate_light(), slate_dark())

  defp neutral_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.145 0 0);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.145 0 0);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.145 0 0);
      --primary: oklch(0.205 0 0);
      --primary-foreground: oklch(0.985 0 0);
      --secondary: oklch(0.97 0 0);
      --secondary-foreground: oklch(0.205 0 0);
      --muted: oklch(0.97 0 0);
      --muted-foreground: oklch(0.556 0 0);
      --accent: oklch(0.97 0 0);
      --accent-foreground: oklch(0.205 0 0);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.922 0 0);
      --input: oklch(0.922 0 0);
      --ring: oklch(0.708 0 0);
      --sidebar: oklch(0.985 0 0);
      --sidebar-foreground: oklch(0.145 0 0);
      --sidebar-primary: oklch(0.205 0 0);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.97 0 0);
      --sidebar-accent-foreground: oklch(0.205 0 0);
      --sidebar-border: oklch(0.922 0 0);
      --sidebar-ring: oklch(0.708 0 0);
    """
  end

  defp neutral_dark do
    """
      --background: oklch(0.145 0 0);
      --foreground: oklch(0.985 0 0);
      --card: oklch(0.205 0 0);
      --card-foreground: oklch(0.985 0 0);
      --popover: oklch(0.205 0 0);
      --popover-foreground: oklch(0.985 0 0);
      --primary: oklch(0.922 0 0);
      --primary-foreground: oklch(0.205 0 0);
      --secondary: oklch(0.269 0 0);
      --secondary-foreground: oklch(0.985 0 0);
      --muted: oklch(0.269 0 0);
      --muted-foreground: oklch(0.708 0 0);
      --accent: oklch(0.269 0 0);
      --accent-foreground: oklch(0.985 0 0);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.556 0 0);
      --sidebar: oklch(0.205 0 0);
      --sidebar-foreground: oklch(0.985 0 0);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.269 0 0);
      --sidebar-accent-foreground: oklch(0.985 0 0);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.556 0 0);
    """
  end

  defp stone_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.147 0.004 49.25);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.147 0.004 49.25);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.147 0.004 49.25);
      --primary: oklch(0.216 0.006 56.043);
      --primary-foreground: oklch(0.985 0.001 106.423);
      --secondary: oklch(0.97 0.001 106.424);
      --secondary-foreground: oklch(0.216 0.006 56.043);
      --muted: oklch(0.97 0.001 106.424);
      --muted-foreground: oklch(0.553 0.013 58.071);
      --accent: oklch(0.97 0.001 106.424);
      --accent-foreground: oklch(0.216 0.006 56.043);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.923 0.003 48.717);
      --input: oklch(0.923 0.003 48.717);
      --ring: oklch(0.709 0.01 56.259);
      --sidebar: oklch(0.985 0.001 106.423);
      --sidebar-foreground: oklch(0.147 0.004 49.25);
      --sidebar-primary: oklch(0.216 0.006 56.043);
      --sidebar-primary-foreground: oklch(0.985 0.001 106.423);
      --sidebar-accent: oklch(0.97 0.001 106.424);
      --sidebar-accent-foreground: oklch(0.216 0.006 56.043);
      --sidebar-border: oklch(0.923 0.003 48.717);
      --sidebar-ring: oklch(0.709 0.01 56.259);
    """
  end

  defp stone_dark do
    """
      --background: oklch(0.147 0.004 49.25);
      --foreground: oklch(0.985 0.001 106.423);
      --card: oklch(0.216 0.006 56.043);
      --card-foreground: oklch(0.985 0.001 106.423);
      --popover: oklch(0.216 0.006 56.043);
      --popover-foreground: oklch(0.985 0.001 106.423);
      --primary: oklch(0.923 0.003 48.717);
      --primary-foreground: oklch(0.216 0.006 56.043);
      --secondary: oklch(0.268 0.007 34.298);
      --secondary-foreground: oklch(0.985 0.001 106.423);
      --muted: oklch(0.268 0.007 34.298);
      --muted-foreground: oklch(0.709 0.01 56.259);
      --accent: oklch(0.268 0.007 34.298);
      --accent-foreground: oklch(0.985 0.001 106.423);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.553 0.013 58.071);
      --sidebar: oklch(0.216 0.006 56.043);
      --sidebar-foreground: oklch(0.985 0.001 106.423);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0.001 106.423);
      --sidebar-accent: oklch(0.268 0.007 34.298);
      --sidebar-accent-foreground: oklch(0.985 0.001 106.423);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.553 0.013 58.071);
    """
  end

  defp zinc_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.141 0.005 285.823);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.141 0.005 285.823);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.141 0.005 285.823);
      --primary: oklch(0.21 0.006 285.885);
      --primary-foreground: oklch(0.985 0 0);
      --secondary: oklch(0.967 0.001 286.375);
      --secondary-foreground: oklch(0.21 0.006 285.885);
      --muted: oklch(0.967 0.001 286.375);
      --muted-foreground: oklch(0.552 0.016 285.938);
      --accent: oklch(0.967 0.001 286.375);
      --accent-foreground: oklch(0.21 0.006 285.885);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.92 0.004 286.32);
      --input: oklch(0.92 0.004 286.32);
      --ring: oklch(0.705 0.015 286.067);
      --sidebar: oklch(0.985 0 0);
      --sidebar-foreground: oklch(0.141 0.005 285.823);
      --sidebar-primary: oklch(0.21 0.006 285.885);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.967 0.001 286.375);
      --sidebar-accent-foreground: oklch(0.21 0.006 285.885);
      --sidebar-border: oklch(0.92 0.004 286.32);
      --sidebar-ring: oklch(0.705 0.015 286.067);
    """
  end

  defp zinc_dark do
    """
      --background: oklch(0.141 0.005 285.823);
      --foreground: oklch(0.985 0 0);
      --card: oklch(0.21 0.006 285.885);
      --card-foreground: oklch(0.985 0 0);
      --popover: oklch(0.21 0.006 285.885);
      --popover-foreground: oklch(0.985 0 0);
      --primary: oklch(0.92 0.004 286.32);
      --primary-foreground: oklch(0.21 0.006 285.885);
      --secondary: oklch(0.274 0.006 286.033);
      --secondary-foreground: oklch(0.985 0 0);
      --muted: oklch(0.274 0.006 286.033);
      --muted-foreground: oklch(0.705 0.015 286.067);
      --accent: oklch(0.274 0.006 286.033);
      --accent-foreground: oklch(0.985 0 0);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.552 0.016 285.938);
      --sidebar: oklch(0.21 0.006 285.885);
      --sidebar-foreground: oklch(0.985 0 0);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.274 0.006 286.033);
      --sidebar-accent-foreground: oklch(0.985 0 0);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.552 0.016 285.938);
    """
  end

  defp gray_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.13 0.028 261.692);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.13 0.028 261.692);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.13 0.028 261.692);
      --primary: oklch(0.21 0.034 264.665);
      --primary-foreground: oklch(0.985 0.002 247.839);
      --secondary: oklch(0.967 0.003 264.542);
      --secondary-foreground: oklch(0.21 0.034 264.665);
      --muted: oklch(0.967 0.003 264.542);
      --muted-foreground: oklch(0.551 0.027 264.364);
      --accent: oklch(0.967 0.003 264.542);
      --accent-foreground: oklch(0.21 0.034 264.665);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.928 0.006 264.531);
      --input: oklch(0.928 0.006 264.531);
      --ring: oklch(0.707 0.022 261.325);
      --sidebar: oklch(0.985 0.002 247.839);
      --sidebar-foreground: oklch(0.13 0.028 261.692);
      --sidebar-primary: oklch(0.21 0.034 264.665);
      --sidebar-primary-foreground: oklch(0.985 0.002 247.839);
      --sidebar-accent: oklch(0.967 0.003 264.542);
      --sidebar-accent-foreground: oklch(0.21 0.034 264.665);
      --sidebar-border: oklch(0.928 0.006 264.531);
      --sidebar-ring: oklch(0.707 0.022 261.325);
    """
  end

  defp gray_dark do
    """
      --background: oklch(0.13 0.028 261.692);
      --foreground: oklch(0.985 0.002 247.839);
      --card: oklch(0.21 0.034 264.665);
      --card-foreground: oklch(0.985 0.002 247.839);
      --popover: oklch(0.21 0.034 264.665);
      --popover-foreground: oklch(0.985 0.002 247.839);
      --primary: oklch(0.928 0.006 264.531);
      --primary-foreground: oklch(0.21 0.034 264.665);
      --secondary: oklch(0.278 0.033 256.848);
      --secondary-foreground: oklch(0.985 0.002 247.839);
      --muted: oklch(0.278 0.033 256.848);
      --muted-foreground: oklch(0.707 0.022 261.325);
      --accent: oklch(0.278 0.033 256.848);
      --accent-foreground: oklch(0.985 0.002 247.839);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.551 0.027 264.364);
      --sidebar: oklch(0.21 0.034 264.665);
      --sidebar-foreground: oklch(0.985 0.002 247.839);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0.002 247.839);
      --sidebar-accent: oklch(0.278 0.033 256.848);
      --sidebar-accent-foreground: oklch(0.985 0.002 247.839);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.551 0.027 264.364);
    """
  end

  defp slate_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.129 0.042 264.695);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.129 0.042 264.695);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.129 0.042 264.695);
      --primary: oklch(0.208 0.042 265.755);
      --primary-foreground: oklch(0.984 0.003 247.858);
      --secondary: oklch(0.968 0.007 247.896);
      --secondary-foreground: oklch(0.208 0.042 265.755);
      --muted: oklch(0.968 0.007 247.896);
      --muted-foreground: oklch(0.554 0.046 257.417);
      --accent: oklch(0.968 0.007 247.896);
      --accent-foreground: oklch(0.208 0.042 265.755);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.929 0.013 255.508);
      --input: oklch(0.929 0.013 255.508);
      --ring: oklch(0.704 0.04 256.788);
      --sidebar: oklch(0.984 0.003 247.858);
      --sidebar-foreground: oklch(0.129 0.042 264.695);
      --sidebar-primary: oklch(0.208 0.042 265.755);
      --sidebar-primary-foreground: oklch(0.984 0.003 247.858);
      --sidebar-accent: oklch(0.968 0.007 247.896);
      --sidebar-accent-foreground: oklch(0.208 0.042 265.755);
      --sidebar-border: oklch(0.929 0.013 255.508);
      --sidebar-ring: oklch(0.704 0.04 256.788);
    """
  end

  defp slate_dark do
    """
      --background: oklch(0.129 0.042 264.695);
      --foreground: oklch(0.984 0.003 247.858);
      --card: oklch(0.208 0.042 265.755);
      --card-foreground: oklch(0.984 0.003 247.858);
      --popover: oklch(0.208 0.042 265.755);
      --popover-foreground: oklch(0.984 0.003 247.858);
      --primary: oklch(0.929 0.013 255.508);
      --primary-foreground: oklch(0.208 0.042 265.755);
      --secondary: oklch(0.279 0.041 260.031);
      --secondary-foreground: oklch(0.984 0.003 247.858);
      --muted: oklch(0.279 0.041 260.031);
      --muted-foreground: oklch(0.704 0.04 256.788);
      --accent: oklch(0.279 0.041 260.031);
      --accent-foreground: oklch(0.984 0.003 247.858);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.551 0.027 264.364);
      --sidebar: oklch(0.208 0.042 265.755);
      --sidebar-foreground: oklch(0.984 0.003 247.858);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.984 0.003 247.858);
      --sidebar-accent: oklch(0.279 0.041 260.031);
      --sidebar-accent-foreground: oklch(0.984 0.003 247.858);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.551 0.027 264.364);
    """
  end
end
