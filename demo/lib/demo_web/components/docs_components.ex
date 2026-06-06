defmodule DemoWeb.DocsComponents do
  @moduledoc """
  Page-assembly helpers for the documentation site, modeled on the layout of
  ui.shadcn.com / shadcn-svelte.com: a full-width site header, a sticky (non-collapsible)
  docs sidebar, an "On This Page" table of contents, and bordered Preview/Code blocks.

  Library components are used where they genuinely fit the docs UX — `tabs` for the
  Preview/Code toggle, `command` + `dialog` for the ⌘K search palette, `table` for props,
  `breadcrumb` for the crumb trail. The site chrome (header, sidebar, TOC) is plain markup,
  since the app-style `sidebar` component is not the right model for documentation nav.
  """
  use Phoenix.Component
  use ShadcnElixir

  import Phoenix.HTML, only: [raw: 1]
  import ShadcnElixir.JS, only: [open_modal: 1]
  alias Phoenix.LiveView.JS
  alias DemoWeb.Docs
  alias DemoWeb.Docs.{Examples, Props}

  # Compile-time Makeup stylesheet (dark monokai). `.highlight` is the default wrapper
  # class emitted by `Makeup.highlight/2`.
  @makeup_css Makeup.stylesheet(Makeup.Styles.HTML.StyleMap.monokai_style(), "highlight")
  @github_url "https://github.com/N00nDay/shadcn-elixir"

  @doc """
  The documentation shell: site header, sticky docs sidebar, content column, and TOC.

    * `active` — `{:page, slug}` or `{:component, slug}` to mark the current sidebar item.
    * `breadcrumb` — list of `%{label, href}` (href nil = current page).
    * `toc` — list of `%{id, label}` (optional `depth: 2` for nested items).
  """
  attr :active, :any, default: nil
  attr :breadcrumb, :list, default: []
  attr :toc, :list, default: []
  slot :inner_block, required: true

  def docs_shell(assigns) do
    assigns = assign(assigns, components: Docs.components(), makeup_css: @makeup_css)

    ~H"""
    {raw("<style>" <> @makeup_css <> "</style>")}
    <.search_dialog components={@components} />
    <div class="min-h-svh bg-background text-foreground">
      <.site_header components={@components} />
      <div class="mx-auto flex w-full max-w-screen-2xl">
        <.docs_sidebar active={@active} components={@components} />
        <main class="min-w-0 flex-1">
          <div class="mx-auto flex w-full max-w-5xl gap-12 px-6 py-10 lg:px-10">
            <article class="min-w-0 flex-1">
              <.docs_breadcrumb :if={@breadcrumb != []} crumbs={@breadcrumb} />
              {render_slot(@inner_block)}
            </article>
            <.docs_toc :if={@toc != []} toc={@toc} />
          </div>
          <.docs_footer />
        </main>
      </div>
    </div>
    """
  end

  # --- Footer (attribution) --------------------------------------------------

  @doc "Attribution footer (shared by docs pages and the landing page)."
  def docs_footer(assigns) do
    assigns = assign(assigns, :github_url, @github_url)

    ~H"""
    <footer class="mt-12 border-t py-8">
      <div class="mx-auto max-w-5xl px-6 lg:px-10">
        <p class="text-sm text-balance text-muted-foreground">
          Built by <.link
            href="https://twitter.com/shadcn"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >shadcn</.link>. Ported to Phoenix by <.link
            href="https://github.com/N00nDay"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >Craig Howell</.link>. The source code is available on <.link
            href={@github_url}
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >GitHub</.link>.
        </p>
      </div>
    </footer>
    """
  end

  # --- Site header -----------------------------------------------------------

  @doc "Top site header (shared by docs pages and the landing page)."
  attr :components, :list, required: true

  def site_header(assigns) do
    assigns = assign(assigns, :github_url, @github_url)

    ~H"""
    <header class="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div class="mx-auto flex h-14 max-w-screen-2xl items-center gap-4 px-6 lg:px-10">
        <.link navigate="/" class="flex items-center gap-2 text-base font-semibold">
          shadcn-elixir
        </.link>
        <nav class="hidden items-center gap-4 text-sm font-medium md:flex">
          <.link navigate="/" class="text-foreground/70 transition-colors hover:text-foreground">
            Home
          </.link>
          <.link
            navigate="/docs/introduction"
            class="text-foreground/70 transition-colors hover:text-foreground"
          >
            Docs
          </.link>
          <.link
            navigate="/docs/components/button"
            class="text-foreground/70 transition-colors hover:text-foreground"
          >
            Components
          </.link>
          <.link href="#" class="text-foreground/70 transition-colors hover:text-foreground">
            Blocks
          </.link>
          <.link href="#" class="text-foreground/70 transition-colors hover:text-foreground">
            Charts
          </.link>
          <.link href="#" class="text-foreground/70 transition-colors hover:text-foreground">
            Create
          </.link>
        </nav>
        <div class="ml-auto flex items-center gap-2">
          <.search_trigger />
          <a
            href={@github_url}
            target="_blank"
            rel="noreferrer"
            aria-label="GitHub"
            class="inline-flex size-9 items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground"
          >
            <svg viewBox="0 0 24 24" fill="currentColor" class="size-4" aria-hidden="true">
              <path d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0 1 12 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.02 10.02 0 0 0 22 12.017C22 6.484 17.522 2 12 2Z" />
            </svg>
          </a>
          <button
            type="button"
            onclick="toggleTheme()"
            aria-label="Toggle theme"
            class="inline-flex size-9 items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 dark:hidden"
            >
              <circle cx="12" cy="12" r="4" /><path d="M12 2v2" /><path d="M12 20v2" /><path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" /><path d="M2 12h2" /><path d="M20 12h2" /><path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" />
            </svg>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="hidden size-4 dark:block"
            >
              <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
    """
  end

  # --- ⌘K search palette (dialog + command) ----------------------------------
  #
  # The trigger lives in the header, but the dialog is rendered at the docs root.
  # A `backdrop-filter`/`blur` ancestor (the sticky header) becomes the containing
  # block for `position: fixed`, which would anchor the modal to the header instead
  # of the viewport — so the two are split and wired by id via `open_modal/1`.

  defp search_trigger(assigns) do
    ~H"""
    <button
      id="docs-search-trigger"
      type="button"
      phx-hook="CommandK"
      phx-click={open_modal("docs-search")}
      class="inline-flex h-9 w-9 items-center gap-2 rounded-md border bg-muted/40 px-0 text-sm text-muted-foreground transition-colors hover:bg-muted sm:w-64 sm:px-3 lg:w-72"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="size-4 shrink-0 max-sm:mx-auto"
      >
        <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
      </svg>
      <span class="hidden truncate whitespace-nowrap sm:inline">Search components...</span>
      <kbd class="ml-auto hidden items-center gap-1 rounded border bg-background px-1.5 font-mono text-[10px] font-medium sm:inline-flex">
        ⌘K
      </kbd>
    </button>
    """
  end

  @doc "The ⌘K search command palette dialog (shared by docs pages and the landing page)."
  attr :components, :list, required: true

  def search_dialog(assigns) do
    ~H"""
    <.dialog id="docs-search">
      <.dialog_content dialog="docs-search" show_close={false} class="overflow-hidden p-0 sm:max-w-lg">
        <.command id="docs-search-cmd" class="[&_[data-slot=command-input-wrapper]]:h-11">
          <.command_input placeholder="Search documentation..." />
          <.command_list>
            <.command_empty>No results found.</.command_empty>
            <.command_group heading="Components">
              <.command_item
                :for={c <- @components}
                value={c.title}
                phx-click={JS.navigate("/docs/components/#{c.slug}")}
              >
                {c.title}
              </.command_item>
            </.command_group>
          </.command_list>
        </.command>
      </.dialog_content>
    </.dialog>
    """
  end

  # --- Docs sidebar (sticky, non-collapsible) --------------------------------

  attr :active, :any, required: true
  attr :components, :list, required: true

  defp docs_sidebar(assigns) do
    ~H"""
    <aside class="sticky top-14 hidden h-[calc(100svh-3.5rem)] w-60 shrink-0 overflow-y-auto border-r px-3 py-8 md:block">
      <nav class="space-y-6">
        <div>
          <p class="mb-2 px-2 text-sm font-semibold">Getting Started</p>
          <ul class="space-y-0.5">
            <li :for={page <- Docs.getting_started()}>
              <.link
                navigate={"/docs/#{page.slug}"}
                class={nav_link_class(@active == {:page, page.slug})}
              >
                {page.title}
              </.link>
            </li>
          </ul>
        </div>
        <div>
          <p class="mb-2 px-2 text-sm font-semibold">Components</p>
          <ul class="space-y-0.5">
            <li :for={c <- @components}>
              <.link
                navigate={"/docs/components/#{c.slug}"}
                class={nav_link_class(@active == {:component, c.slug})}
              >
                <span>{c.title}</span>
                <span :if={not c.built} class="ml-auto text-[10px] uppercase tracking-wide opacity-50">
                  soon
                </span>
              </.link>
            </li>
          </ul>
        </div>
      </nav>
    </aside>
    """
  end

  defp nav_link_class(active?) do
    [
      "flex items-center rounded-md px-2 py-1.5 text-sm transition-colors",
      if(active?,
        do: "bg-accent font-medium text-accent-foreground",
        else: "text-muted-foreground hover:text-foreground"
      )
    ]
  end

  # --- Breadcrumb + table of contents ----------------------------------------

  attr :crumbs, :list, required: true

  defp docs_breadcrumb(assigns) do
    ~H"""
    <.breadcrumb class="mb-4">
      <.breadcrumb_list>
        <%= for {crumb, idx} <- Enum.with_index(@crumbs) do %>
          <.breadcrumb_separator :if={idx > 0} />
          <.breadcrumb_item>
            <.breadcrumb_link :if={crumb.href} navigate={crumb.href}>{crumb.label}</.breadcrumb_link>
            <.breadcrumb_page :if={is_nil(crumb.href)}>{crumb.label}</.breadcrumb_page>
          </.breadcrumb_item>
        <% end %>
      </.breadcrumb_list>
    </.breadcrumb>
    """
  end

  attr :toc, :list, required: true

  defp docs_toc(assigns) do
    ~H"""
    <aside class="hidden w-56 shrink-0 xl:block">
      <div class="sticky top-20">
        <p class="mb-3 text-sm font-medium">On This Page</p>
        <ul class="space-y-2 text-sm">
          <li :for={item <- @toc}>
            <a
              href={"#" <> item.id}
              class={[
                "block text-muted-foreground transition-colors hover:text-foreground",
                Map.get(item, :depth, 1) == 2 && "pl-3"
              ]}
            >
              {item.label}
            </a>
          </li>
        </ul>
      </div>
    </aside>
    """
  end

  # --- Page content helpers --------------------------------------------------

  @doc "Page heading: title + lead description."
  attr :title, :string, required: true
  attr :description, :string, default: nil

  def doc_heading(assigns) do
    ~H"""
    <div class="space-y-3 pb-4">
      <h1 class="scroll-m-20 text-3xl font-bold tracking-tight">{@title}</h1>
      <p :if={@description} class="text-base text-balance text-muted-foreground">{@description}</p>
    </div>
    """
  end

  @doc "A section heading (rendered as an `h2` with an anchor id for the TOC)."
  attr :id, :string, default: nil
  slot :inner_block, required: true

  def doc_section_title(assigns) do
    ~H"""
    <h2
      id={@id}
      class="mt-12 mb-4 scroll-m-20 border-b pb-2 text-xl font-semibold tracking-tight first:mt-0"
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  A Preview/Code block for a registered example. Renders the live component in the
  Preview tab and its exact source (from the same partial) in the Code tab.
  """
  attr :name, :string, required: true

  def example(assigns) do
    assigns = assign(assigns, :tab_id, "ex-" <> assigns.name)

    ~H"""
    <div class="relative my-4">
      <.tabs id={@tab_id}>
        <.tabs_list variant="line">
          <.tabs_trigger tabs={@tab_id} value="preview" active class="flex-none px-3">
            Preview
          </.tabs_trigger>
          <.tabs_trigger tabs={@tab_id} value="code" class="flex-none px-3">Code</.tabs_trigger>
        </.tabs_list>
        <.tabs_content tabs={@tab_id} value="preview" active>
          <div class="flex min-h-[350px] w-full items-center justify-center rounded-md border p-10">
            {Examples.render(@name)}
          </div>
        </.tabs_content>
        <.tabs_content tabs={@tab_id} value="code">
          <.code_block id={"code-" <> @name} source={Examples.source(@name)} />
        </.tabs_content>
      </.tabs>
    </div>
    """
  end

  @doc "A syntax-highlighted code block with a copy button."
  attr :id, :string, required: true
  attr :source, :string, required: true
  attr :language, :string, default: "heex"

  def code_block(assigns) do
    assigns = assign(assigns, :html, highlight(assigns.source, assigns.language))

    ~H"""
    <div class="relative">
      <button
        id={@id}
        type="button"
        phx-hook="CopyCode"
        data-code={@source}
        aria-label="Copy code"
        class="copy-btn absolute right-3 top-3 z-10 inline-flex size-7 items-center justify-center rounded-md bg-zinc-800 text-zinc-300 transition-colors hover:bg-zinc-700 hover:text-zinc-100"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="copy-icon size-3.5"
        >
          <rect width="14" height="14" x="8" y="8" rx="2" ry="2" /><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
        </svg>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="check-icon size-3.5"
        >
          <path d="M20 6 9 17l-5-5" />
        </svg>
      </button>
      <div class="makeup-wrap overflow-hidden rounded-md">
        {raw(@html)}
      </div>
    </div>
    """
  end

  @doc "Auto-generated props table for `module.fun`, built from declarative attr metadata."
  attr :module, :atom, required: true
  attr :fun, :atom, required: true
  attr :label, :string, default: nil

  def props_table(assigns) do
    assigns = assign(assigns, :attrs, Props.attrs(assigns.module, assigns.fun))

    ~H"""
    <div class="space-y-3">
      <h4 :if={@label} class="font-mono text-sm font-medium">{"<.#{@label}>"}</h4>
      <.table>
        <.table_header>
          <.table_row>
            <.table_head>Prop</.table_head>
            <.table_head>Type</.table_head>
            <.table_head>Default</.table_head>
            <.table_head class="w-1/2">Description</.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row :for={a <- @attrs}>
            <.table_cell class="font-mono text-xs">
              {a.name}<span :if={a.required} class="text-destructive">*</span>
            </.table_cell>
            <.table_cell class="font-mono text-xs text-muted-foreground">{a.type}</.table_cell>
            <.table_cell class="font-mono text-xs text-muted-foreground">
              {a.default || "—"}
            </.table_cell>
            <.table_cell class="text-xs whitespace-normal text-muted-foreground">
              {a.doc}
              <span :if={enum_values(a.values) != []} class="mt-1 block">
                <span class="text-foreground/70">One of:</span>
                <code
                  :for={v <- enum_values(a.values)}
                  class="mr-1 rounded bg-muted px-1 py-0.5 text-[11px]"
                >
                  {inspect(v)}
                </code>
              </span>
            </.table_cell>
          </.table_row>
        </.table_body>
      </.table>
    </div>
    """
  end

  defp enum_values(nil), do: []
  defp enum_values(values), do: Enum.reject(values, &is_nil/1)

  defp highlight(source, "elixir"), do: Makeup.highlight(source, lexer: Makeup.Lexers.ElixirLexer)
  defp highlight(source, "heex"), do: Makeup.highlight(source, lexer: Makeup.Lexers.HEExLexer)

  defp highlight(source, _plain) do
    escaped = source |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()
    ~s(<pre class="highlight"><code>#{escaped}</code></pre>)
  end
end
