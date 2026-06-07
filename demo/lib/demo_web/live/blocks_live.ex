defmodule DemoWeb.BlocksLive do
  @moduledoc """
  The Blocks showcase (`/blocks/:category`), modeled on shadcn-svelte.com/blocks: the shared
  site header, a hero, a category nav row, and a stacked column of "block viewer" frames. Each
  frame has a Preview/Code toolbar and renders a real block rebuilt with the library's
  components (see `DemoWeb.Blocks.Previews`).

  Uses plain `Phoenix.LiveView` + `use ShadcnElixir` (rather than `DemoWeb, :live_view`) to
  avoid name clashes with Phoenix core_components. Mirrors `DemoWeb.ChartsLive`.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents,
    only: [site_header: 1, docs_footer: 1, search_dialog: 1, code_block: 1]

  alias DemoWeb.{Blocks, Docs, DocsComponents, Themes}
  alias DemoWeb.Blocks.Previews
  alias Phoenix.HTML

  def mount(_params, _session, socket) do
    {:ok, assign(socket, components: Docs.components(), base: "neutral")}
  end

  def handle_params(params, _uri, socket) do
    category = params["category"] || "featured"
    category = if Blocks.category?(category), do: category, else: "featured"

    {:noreply,
     assign(socket,
       category: category,
       page_title: "Blocks — " <> Blocks.category_title(category),
       blocks: Blocks.blocks(category)
     )}
  end

  # The base-color theme selector re-themes the block previews.
  def handle_event("set_theme", %{"base" => base}, socket) do
    {:noreply, if(Themes.base?(base), do: assign(socket, base: base), else: socket)}
  end

  def render(assigns) do
    ~H"""
    {HTML.raw("<style>" <> DocsComponents.makeup_css() <> Themes.scoped_css() <> "</style>")}
    <.search_dialog components={@components} />
    <div class="min-h-svh bg-background text-foreground">
      <.site_header components={@components} />
      <main class="flex flex-1 flex-col">
        <section>
          <div class="mx-auto flex max-w-screen-2xl flex-col items-center gap-2 px-6 py-8 text-center md:py-16 lg:py-20 xl:gap-4">
            <.link
              navigate="/create/preview-02"
              class="bg-muted text-foreground inline-flex items-center gap-1 rounded-full px-3 py-1 text-sm font-medium"
            >
              Introducing Rhea
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                class="size-4"
                aria-hidden="true"
              >
                <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
              </svg>
            </.link>
            <h1 class="max-w-3xl text-3xl font-semibold tracking-tight text-balance text-primary lg:leading-[1.1] xl:text-5xl xl:tracking-tighter">
              Building Blocks for the Web
            </h1>
            <p class="max-w-4xl text-base text-balance text-foreground sm:text-lg">
              Clean, modern building blocks. Works with all Svelte projects. Copy and paste into
              your apps. Open Source. Free forever.
            </p>
            <div class="flex w-full items-center justify-center gap-2 pt-2">
              <.button href="#blocks" size="sm">Browse Blocks</.button>
            </div>
          </div>
        </section>

        <div id="blocks" class="scroll-mt-24">
          <div class="mx-auto flex max-w-screen-2xl items-center justify-between gap-4 px-6 py-4">
            <nav class="flex items-center overflow-x-auto">
              <.link
                :for={{slug, title} <- Blocks.categories()}
                navigate={"/blocks/#{slug}"}
                data-active={to_string(@category == slug)}
                class="flex h-7 shrink-0 items-center justify-center px-4 text-center text-base font-medium text-muted-foreground transition-colors hover:text-primary data-[active=true]:text-primary"
              >
                {title}
              </.link>
            </nav>
            <div class="flex shrink-0 items-center gap-2">
              <.button
                navigate="/blocks/sidebar"
                variant="secondary"
                size="sm"
                class="hidden shadow-none lg:flex"
              >
                Browse all blocks
              </.button>
              <form phx-change="set_theme">
                <.select id="theme-select" name="base" value={@base} phx-update="ignore">
                  <.select_trigger
                    select="theme-select"
                    size="sm"
                    class="w-[130px]"
                    aria-label="Select a theme"
                  >
                    <.select_value placeholder="Neutral" />
                  </.select_trigger>
                  <.select_content select="theme-select">
                    <.select_item
                      :for={{slug, title} <- Themes.bases()}
                      select="theme-select"
                      value={slug}
                    >
                      {title}
                    </.select_item>
                  </.select_content>
                </.select>
              </form>
            </div>
          </div>
        </div>

        <div
          data-base={@base}
          class="mx-auto w-full max-w-screen-2xl bg-background px-6 pt-4 pb-8 text-foreground"
        >
          <div class="flex flex-col gap-12 md:gap-24">
            <.block_viewer :for={block <- @blocks} block={block} />
          </div>
        </div>
        <.docs_footer />
      </main>
    </div>
    """
  end

  attr :block, :map, required: true

  defp block_viewer(assigns) do
    assigns =
      assigns
      |> assign(:tab_id, "bv-" <> assigns.block.name)
      |> assign(:command, "mix shadcn.add " <> assigns.block.name)

    ~H"""
    <div
      id={@block.name}
      class="group/block-view-wrapper flex min-w-0 scroll-mt-24 flex-col items-stretch gap-4"
    >
      <.tabs id={@tab_id} class="gap-4">
        <div class="flex w-full items-center gap-2 ps-1">
          <.tabs_list variant="line" class="h-8">
            <.tabs_trigger tabs={@tab_id} value="preview" active class="flex-none px-3 text-xs">
              Preview
            </.tabs_trigger>
            <.tabs_trigger tabs={@tab_id} value="code" class="flex-none px-3 text-xs">
              Code
            </.tabs_trigger>
          </.tabs_list>
          <.separator orientation="vertical" class="mx-2 hidden h-4 lg:flex" />
          <a
            :if={@block.description}
            href={"##{@block.name}"}
            class="hidden flex-1 text-sm font-medium underline-offset-2 hover:underline lg:inline md:text-start"
          >
            {String.replace_suffix(@block.description, ".", "")}
          </a>
          <div class="ms-auto flex items-center gap-2">
            <div class="hidden h-8 items-center gap-1.5 rounded-md border p-1 shadow-none md:flex">
              <span
                title="Desktop"
                class="bg-muted text-foreground flex size-6 items-center justify-center rounded-sm"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-3.5"
                  aria-hidden="true"
                >
                  <rect width="20" height="14" x="2" y="3" rx="2" /><line
                    x1="8"
                    x2="16"
                    y1="21"
                    y2="21"
                  /><line x1="12" x2="12" y1="17" y2="21" />
                </svg>
              </span>
              <span
                title="Tablet"
                class="text-muted-foreground flex size-6 items-center justify-center rounded-sm"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-3.5"
                  aria-hidden="true"
                >
                  <rect width="16" height="20" x="4" y="2" rx="2" ry="2" /><line
                    x1="12"
                    x2="12.01"
                    y1="18"
                    y2="18"
                  />
                </svg>
              </span>
              <span
                title="Mobile"
                class="text-muted-foreground flex size-6 items-center justify-center rounded-sm"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-3.5"
                  aria-hidden="true"
                >
                  <rect width="14" height="20" x="5" y="2" rx="2" ry="2" /><path d="M12 18h.01" />
                </svg>
              </span>
            </div>
            <.separator orientation="vertical" class="mx-1 hidden h-4 md:flex" />
            <button
              id={"copy-#{@block.name}"}
              type="button"
              phx-hook="CopyCode"
              data-code={@command}
              aria-label={"Copy install command for #{@block.name}"}
              class="copy-btn border-input bg-background hover:bg-accent hover:text-accent-foreground inline-flex h-8 w-fit items-center gap-1 rounded-md border px-2 text-xs font-medium shadow-none"
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
                <path d="m7 11 2-2-2-2" /><path d="M11 13h4" /><rect
                  width="18"
                  height="18"
                  x="3"
                  y="3"
                  rx="2"
                  ry="2"
                />
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
              <span class="hidden font-mono lg:inline">{@command}</span>
            </button>
          </div>
        </div>
        <.tabs_content tabs={@tab_id} value="preview" active>
          <div
            class="relative w-full overflow-hidden rounded-lg border bg-background"
            style={"height: #{@block.height}"}
          >
            {Previews.render(@block.name)}
          </div>
        </.tabs_content>
        <.tabs_content tabs={@tab_id} value="code">
          <.code_block
            id={"code-#{@block.name}"}
            source={Previews.source(@block.name)}
            language="heex"
          />
        </.tabs_content>
      </.tabs>
    </div>
    """
  end
end
