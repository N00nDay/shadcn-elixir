defmodule ShadcnElixir.Components.Sidebar do
  @moduledoc """
  Sidebar — a port of shadcn/ui's
  [Sidebar](https://ui.shadcn.com/docs/components/sidebar).

  An app sidebar with a collapsible state toggled via `Phoenix.LiveView.JS`. Composed of
  `sidebar_provider/1`, `sidebar/1`, `sidebar_trigger/1`, `sidebar_header/1`,
  `sidebar_content/1`, `sidebar_footer/1`, `sidebar_group/1`, `sidebar_group_label/1`,
  `sidebar_group_content/1`, `sidebar_menu/1`, `sidebar_menu_item/1`,
  `sidebar_menu_button/1`, `sidebar_separator/1`, and `sidebar_inset/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  alias Phoenix.LiveView.JS

  attr(:id, :string, default: "sidebar")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_provider(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="sidebar-provider"
      data-state="expanded"
      style="--sidebar-width: 16rem; --sidebar-width-icon: 3rem;"
      class={cn(["group/sidebar-wrapper flex min-h-svh w-full", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:side, :string, default: "left", values: ["left", "right"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar(assigns) do
    ~H"""
    <aside
      data-slot="sidebar"
      data-side={@side}
      class={
        cn([
          "bg-sidebar text-sidebar-foreground flex h-svh shrink-0 flex-col border-r transition-[width]",
          "duration-200",
          # State-based widths (mutually exclusive) so neither overrides the other by source
          # order — Tailwind v4 wraps group-data variants in :where() (0 specificity).
          "group-data-[state=expanded]/sidebar-wrapper:w-(--sidebar-width)",
          "group-data-[state=collapsed]/sidebar-wrapper:w-(--sidebar-width-icon)",
          "group-data-[state=collapsed]/sidebar-wrapper:overflow-hidden",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </aside>
    """
  end

  attr(:target, :string, default: "sidebar")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="sidebar-trigger"
      aria-label="Toggle sidebar"
      phx-click={JS.toggle_attribute({"data-state", "collapsed", "expanded"}, to: "##{@target}")}
      class={
        cn([
          "inline-flex size-7 items-center justify-center rounded-md hover:bg-sidebar-accent",
          "hover:text-sidebar-accent-foreground",
          @class
        ])
      }
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
        <rect width="18" height="18" x="3" y="3" rx="2" /><path d="M9 3v18" />
      </svg>
    </button>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_header(assigns) do
    ~H"""
    <div data-slot="sidebar-header" class={cn(["flex flex-col gap-2 p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_content(assigns) do
    ~H"""
    <div
      data-slot="sidebar-content"
      class={
        cn([
          "flex min-h-0 flex-1 flex-col gap-2 overflow-auto",
          "group-data-[state=collapsed]/sidebar-wrapper:overflow-hidden",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_footer(assigns) do
    ~H"""
    <div data-slot="sidebar-footer" class={cn(["flex flex-col gap-2 p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_group(assigns) do
    ~H"""
    <div
      data-slot="sidebar-group"
      class={cn(["relative flex w-full min-w-0 flex-col p-2", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_group_label(assigns) do
    ~H"""
    <div
      data-slot="sidebar-group-label"
      class={
        cn([
          "text-sidebar-foreground/70 flex h-8 shrink-0 items-center rounded-md px-2 text-xs",
          "font-medium outline-none transition-[margin,opacity] duration-200 ease-linear",
          "group-data-[state=collapsed]/sidebar-wrapper:-mt-8",
          "group-data-[state=collapsed]/sidebar-wrapper:opacity-0",
          "group-data-[state=collapsed]/sidebar-wrapper:pointer-events-none",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_group_content(assigns) do
    ~H"""
    <div data-slot="sidebar-group-content" class={cn(["w-full text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_menu(assigns) do
    ~H"""
    <ul data-slot="sidebar-menu" class={cn(["flex w-full min-w-0 flex-col gap-1", @class])} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_menu_item(assigns) do
    ~H"""
    <li data-slot="sidebar-menu-item" class={cn(["group/menu-item relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr(:active, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def sidebar_menu_button(assigns) do
    ~H"""
    <.link
      data-slot="sidebar-menu-button"
      data-active={to_string(@active)}
      class={
        cn([
          "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left",
          "text-sm outline-none ring-sidebar-ring transition-[width,height,padding]",
          "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2",
          "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
          "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none",
          "aria-disabled:opacity-50 data-[active=true]:bg-sidebar-accent",
          "data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground",
          "group-data-[state=collapsed]/sidebar-wrapper:size-8!",
          "group-data-[state=collapsed]/sidebar-wrapper:p-2!",
          "[&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def sidebar_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="sidebar-separator"
      class={cn(["bg-sidebar-border mx-2 my-1 h-px w-auto", @class])}
      {@rest}
    />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_inset(assigns) do
    ~H"""
    <main data-slot="sidebar-inset" class={cn(["relative flex min-h-svh flex-1 flex-col", @class])} {@rest}>
      {render_slot(@inner_block)}
    </main>
    """
  end
end
