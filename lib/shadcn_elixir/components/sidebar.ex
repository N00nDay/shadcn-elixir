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

  attr(:collapsible, :string,
    default: "icon",
    values: ["icon", "offcanvas"],
    doc:
      "Collapsed behavior: `icon` keeps an icon rail; `offcanvas` hides the sidebar entirely " <>
        "(use for sidebars whose menu items have no icons)."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar(assigns) do
    ~H"""
    <aside
      data-slot="sidebar"
      data-side={@side}
      data-collapsible={@collapsible}
      class={
        cn([
          "bg-sidebar text-sidebar-foreground flex h-svh shrink-0 flex-col border-r transition-[width]",
          "duration-200 group-data-[state=collapsed]/sidebar-wrapper:overflow-hidden",
          # State-based widths (mutually exclusive) so neither overrides the other by source
          # order — Tailwind v4 wraps group-data variants in :where() (0 specificity).
          "group-data-[state=expanded]/sidebar-wrapper:w-(--sidebar-width)",
          sidebar_collapsed_width(@collapsible),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </aside>
    """
  end

  # `offcanvas` collapses to zero width (fully hidden); `icon` keeps the icon rail.
  defp sidebar_collapsed_width("offcanvas"),
    do:
      "group-data-[state=collapsed]/sidebar-wrapper:w-0 group-data-[state=collapsed]/sidebar-wrapper:border-0"

  defp sidebar_collapsed_width(_),
    do: "group-data-[state=collapsed]/sidebar-wrapper:w-(--sidebar-width-icon)"

  attr(:target, :string, default: "sidebar")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="sidebar-trigger"
      aria-label="Toggle sidebar"
      aria-controls={@target}
      aria-expanded="true"
      phx-click={
        JS.toggle_attribute({"data-state", "collapsed", "expanded"}, to: "##{@target}")
        |> JS.toggle_attribute({"aria-expanded", "false", "true"})
      }
      class={
        cn([
          "inline-flex size-7 items-center justify-center rounded-md hover:bg-sidebar-accent",
          "hover:text-sidebar-accent-foreground",
          @class
        ])
      }
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4" aria-hidden="true">
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

  attr(:size, :string,
    default: "default",
    values: ["default", "sm", "lg"],
    doc:
      "Button size. `lg` (e.g. a header/footer with an 8-size logo) collapses to the icon rail."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def sidebar_menu_button(assigns) do
    # Render an `<a>` when used for navigation; otherwise a real `<button>` (e.g. a collapsible
    # submenu trigger) so clicks don't jump to the top of the page.
    link? = Enum.any?([:href, :navigate, :patch], &Map.has_key?(assigns.rest, &1))

    assigns =
      assigns
      |> assign(:link?, link?)
      |> assign(
        :button_class,
        cn([
          "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left",
          "text-sm outline-none ring-sidebar-ring transition-[width,height,padding]",
          "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2",
          "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
          "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none",
          "aria-disabled:opacity-50 data-[active=true]:bg-sidebar-accent",
          "data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground",
          "group-data-[state=collapsed]/sidebar-wrapper:size-8!",
          "[&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0",
          menu_button_size(assigns.size),
          assigns.class
        ])
      )

    ~H"""
    <.link
      :if={@link?}
      data-slot="sidebar-menu-button"
      data-size={@size}
      data-active={to_string(@active)}
      aria-current={@active && "page"}
      class={@button_class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <button
      :if={not @link?}
      type="button"
      data-slot="sidebar-menu-button"
      data-size={@size}
      data-active={to_string(@active)}
      class={@button_class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  # `lg` keeps an 8-size logo/avatar centered in the collapsed rail by dropping the padding
  # (so the size-8 child fills the size-8 button) instead of being squished by `p-2`.
  defp menu_button_size("sm"), do: "h-7 text-xs group-data-[state=collapsed]/sidebar-wrapper:p-2!"
  defp menu_button_size("lg"), do: "h-12 group-data-[state=collapsed]/sidebar-wrapper:p-0!"
  defp menu_button_size(_), do: "h-8 group-data-[state=collapsed]/sidebar-wrapper:p-2!"

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc "A nested submenu list under a `sidebar_menu_item/1`. Hidden when the rail is collapsed."
  def sidebar_menu_sub(assigns) do
    ~H"""
    <ul
      data-slot="sidebar-menu-sub"
      class={
        cn([
          "border-sidebar-border mx-3.5 flex min-w-0 translate-x-px flex-col gap-1 border-l",
          "px-2.5 py-0.5",
          "group-data-[state=collapsed]/sidebar-wrapper:hidden",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc "A `sidebar_menu_sub/1` list item."
  def sidebar_menu_sub_item(assigns) do
    ~H"""
    <li
      data-slot="sidebar-menu-sub-item"
      class={cn(["group/menu-sub-item relative", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr(:active, :boolean, default: false)

  attr(:size, :string,
    default: "md",
    values: ["sm", "md"],
    doc: "Submenu button text size."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  @doc "A link inside a `sidebar_menu_sub_item/1`."
  def sidebar_menu_sub_button(assigns) do
    ~H"""
    <.link
      data-slot="sidebar-menu-sub-button"
      data-size={@size}
      data-active={to_string(@active)}
      aria-current={@active && "page"}
      class={
        cn([
          "text-sidebar-foreground ring-sidebar-ring flex h-7 min-w-0 -translate-x-px items-center",
          "gap-2 overflow-hidden rounded-md px-2 outline-none",
          "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2",
          "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
          "disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none",
          "aria-disabled:opacity-50",
          "data-[active=true]:bg-sidebar-accent data-[active=true]:text-sidebar-accent-foreground",
          "group-data-[state=collapsed]/sidebar-wrapper:hidden",
          "[&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0",
          "[&>svg]:text-sidebar-accent-foreground",
          @size == "sm" && "text-xs",
          @size == "md" && "text-sm",
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
