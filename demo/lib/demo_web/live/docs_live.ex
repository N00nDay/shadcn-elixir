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

  defp toc_for("installation") do
    [
      %{id: "add-dependency", label: "Add the dependency"},
      %{id: "tw-merge-cache", label: "Start the tw_merge cache"},
      %{id: "import-components", label: "Import the components"},
      %{id: "scan-tailwind", label: "Scan the markup"}
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
    <p class="mt-6 text-sm leading-7 text-muted-foreground">
      This wires up shadcn's semantic tokens
      (<code class="text-xs">--background</code>, <code class="text-xs">--primary</code>, <code class="text-xs">--muted</code>, <code class="text-xs">--destructive</code>, <code class="text-xs">--radius</code>, …) for both light and
      <code class="text-xs">.dark</code>
      modes. Override any token in your own <code class="text-xs">:root</code>/<code class="text-xs">.dark</code> block to re-theme.
    </p>
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
end
