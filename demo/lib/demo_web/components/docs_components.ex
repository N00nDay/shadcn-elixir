defmodule DemoWeb.DocsComponents do
  @moduledoc """
  Page-assembly helpers for the documentation site.

  These are **not** new UI components — they are thin compositions of the library's own
  components (`sidebar`, `tabs`, `card`, `table`, `breadcrumb`, `button`, ...) used to lay
  out the docs. Building the docs entirely from the library is a deliberate dogfooding test.
  """
  use Phoenix.Component
  use ShadcnElixir

  import Phoenix.HTML, only: [raw: 1]

  alias DemoWeb.Docs
  alias DemoWeb.Docs.{Examples, Props}

  # Compile-time Makeup stylesheet (dark monokai). The `.highlight` class is the default
  # wrapper emitted by `Makeup.highlight/2`.
  @makeup_css Makeup.stylesheet(Makeup.Styles.HTML.StyleMap.monokai_style(), "highlight")

  @doc """
  The documentation shell: a library `sidebar` for navigation, a top bar with a
  breadcrumb and theme toggle, and the page body.

  `active` marks the current sidebar entry — `{:page, slug}` or `{:component, slug}`.
  """
  attr :active, :any, default: nil
  attr :breadcrumb, :list, default: [], doc: "list of %{label, href} (href nil = current)"
  slot :inner_block, required: true

  def docs_shell(assigns) do
    assigns = assign(assigns, components: Docs.components(), makeup_css: @makeup_css)

    ~H"""
    {raw("<style>" <> @makeup_css <> "</style>")}
    <.sidebar_provider id="docs-sidebar">
      <.sidebar class="hidden md:flex">
        <.sidebar_header>
          <.link navigate="/" class="flex items-center gap-2 px-2 py-1.5 text-base font-semibold">
            shadcn-elixir
          </.link>
        </.sidebar_header>
        <.sidebar_content>
          <.sidebar_group>
            <.sidebar_group_label>Getting Started</.sidebar_group_label>
            <.sidebar_group_content>
              <.sidebar_menu>
                <.sidebar_menu_item :for={page <- Docs.getting_started()}>
                  <.sidebar_menu_button
                    navigate={"/docs/#{page.slug}"}
                    active={@active == {:page, page.slug}}
                  >
                    <span>{page.title}</span>
                  </.sidebar_menu_button>
                </.sidebar_menu_item>
              </.sidebar_menu>
            </.sidebar_group_content>
          </.sidebar_group>
          <.sidebar_group>
            <.sidebar_group_label>Components</.sidebar_group_label>
            <.sidebar_group_content>
              <.sidebar_menu>
                <.sidebar_menu_item :for={c <- @components}>
                  <.sidebar_menu_button
                    navigate={"/docs/components/#{c.slug}"}
                    active={@active == {:component, c.slug}}
                    class={not c.built && "text-muted-foreground"}
                  >
                    <span>{c.title}</span>
                    <span
                      :if={not c.built}
                      class="ml-auto text-[10px] uppercase tracking-wide opacity-60"
                    >
                      soon
                    </span>
                  </.sidebar_menu_button>
                </.sidebar_menu_item>
              </.sidebar_menu>
            </.sidebar_group_content>
          </.sidebar_group>
        </.sidebar_content>
      </.sidebar>
      <.sidebar_inset>
        <header class="sticky top-0 z-10 flex h-14 items-center gap-3 border-b bg-background/95 px-4 backdrop-blur supports-[backdrop-filter]:bg-background/60">
          <.sidebar_trigger target="docs-sidebar" />
          <.separator orientation="vertical" class="h-5" />
          <.breadcrumb>
            <.breadcrumb_list>
              <%= for {crumb, idx} <- Enum.with_index(@breadcrumb) do %>
                <.breadcrumb_separator :if={idx > 0} />
                <.breadcrumb_item>
                  <.breadcrumb_link :if={crumb.href} navigate={crumb.href}>
                    {crumb.label}
                  </.breadcrumb_link>
                  <.breadcrumb_page :if={is_nil(crumb.href)}>{crumb.label}</.breadcrumb_page>
                </.breadcrumb_item>
              <% end %>
            </.breadcrumb_list>
          </.breadcrumb>
          <div class="ml-auto flex items-center gap-1">
            <.button
              variant="ghost"
              size="icon"
              navigate="/gallery"
              aria-label="Gallery"
              title="Kitchen-sink gallery"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <rect width="7" height="7" x="3" y="3" rx="1" /><rect
                  width="7"
                  height="7"
                  x="14"
                  y="3"
                  rx="1"
                /><rect width="7" height="7" x="14" y="14" rx="1" /><rect
                  width="7"
                  height="7"
                  x="3"
                  y="14"
                  rx="1"
                />
              </svg>
            </.button>
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
        </header>
        <div class="mx-auto w-full max-w-3xl px-6 py-10">
          {render_slot(@inner_block)}
        </div>
      </.sidebar_inset>
    </.sidebar_provider>
    """
  end

  @doc "Page heading: title + lead description."
  attr :title, :string, required: true
  attr :description, :string, default: nil

  def doc_heading(assigns) do
    ~H"""
    <div class="space-y-2 pb-2">
      <h1 class="scroll-m-20 text-3xl font-bold tracking-tight">{@title}</h1>
      <p :if={@description} class="text-base text-muted-foreground">{@description}</p>
    </div>
    """
  end

  @doc "A section heading used between examples."
  attr :id, :string, default: nil
  slot :inner_block, required: true

  def doc_section_title(assigns) do
    ~H"""
    <h2 id={@id} class="mt-10 mb-4 scroll-m-20 border-b pb-2 text-xl font-semibold tracking-tight">
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
    <.tabs id={@tab_id} class="my-2">
      <.tabs_list>
        <.tabs_trigger tabs={@tab_id} value="preview" active>Preview</.tabs_trigger>
        <.tabs_trigger tabs={@tab_id} value="code">Code</.tabs_trigger>
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
  defp highlight(source, _heex), do: Makeup.highlight(source, lexer: Makeup.Lexers.HEExLexer)
end
