defmodule ShadcnElixir.Components.NavigationMenu do
  @moduledoc """
  NavigationMenu — a port of shadcn/ui's
  [Navigation Menu](https://ui.shadcn.com/docs/components/navigation-menu).

  Hover/focus-revealed navigation menus (pure CSS via `group-hover`/`group-focus-within`).
  Composed of `navigation_menu/1`, `navigation_menu_list/1`, `navigation_menu_item/1`,
  `navigation_menu_trigger/1`, `navigation_menu_content/1`, and `navigation_menu_link/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:label, :string,
    default: "Main",
    doc: "Accessible name for the navigation landmark (distinguishes multiple <nav>s)."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navigation_menu(assigns) do
    ~H"""
    <nav
      data-slot="navigation-menu"
      aria-label={@label}
      class={
        cn([
          "group/navigation-menu relative flex max-w-max flex-1 items-center justify-center",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </nav>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navigation_menu_list(assigns) do
    ~H"""
    <ul
      data-slot="navigation-menu-list"
      class={cn(["group flex flex-1 list-none items-center justify-center gap-1", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navigation_menu_item(assigns) do
    ~H"""
    <li
      data-slot="navigation-menu-item"
      class={cn(["group/nav-item relative", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navigation_menu_trigger(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="navigation-menu-trigger"
      aria-haspopup="menu"
      class={
        cn([
          "group/nav-trigger bg-background hover:bg-accent hover:text-accent-foreground",
          "focus:bg-accent focus:text-accent-foreground inline-flex h-9 w-max items-center",
          "justify-center rounded-md px-4 py-2 text-sm font-medium outline-none",
          "transition-[color,box-shadow] focus-visible:ring-[3px] focus-visible:ring-ring/50",
          "focus-visible:outline-1 disabled:pointer-events-none disabled:opacity-50",
          "group-hover/nav-item:bg-accent/50 group-hover/nav-item:text-accent-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="relative top-[1px] ml-1 size-3 transition duration-300 group-hover/nav-item:rotate-180"
        aria-hidden="true"
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </button>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navigation_menu_content(assigns) do
    ~H"""
    <div
      data-slot="navigation-menu-content"
      class={
        cn([
          "bg-popover text-popover-foreground absolute top-full left-0 z-50 mt-1.5 w-max rounded-md",
          "border p-2 shadow-md invisible opacity-0 transition-opacity",
          "group-hover/nav-item:visible group-hover/nav-item:opacity-100",
          "group-focus-within/nav-item:visible group-focus-within/nav-item:opacity-100",
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
  attr(:active, :boolean, default: false)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def navigation_menu_link(assigns) do
    ~H"""
    <.link
      data-slot="navigation-menu-link"
      data-active={to_string(@active)}
      aria-current={@active && "page"}
      class={
        cn([
          "hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
          "flex flex-col gap-1 rounded-sm p-2 text-sm outline-none transition-all",
          "focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-1",
          "data-[active=true]:bg-accent/50 data-[active=true]:text-accent-foreground",
          "data-[active=true]:hover:bg-accent data-[active=true]:focus:bg-accent",
          "[&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
