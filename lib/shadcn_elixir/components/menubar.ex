defmodule ShadcnElixir.Components.Menubar do
  @moduledoc """
  Menubar — a port of shadcn/ui's
  [Menubar](https://ui.shadcn.com/docs/components/menubar).

  A horizontal bar of menus. Composed of `menubar/1`, `menubar_menu/1`,
  `menubar_trigger/1`, `menubar_content/1`, `menubar_item/1`, `menubar_label/1`,
  `menubar_separator/1`, and `menubar_shortcut/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [toggle: 1, close: 1]

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar(assigns) do
    ~H"""
    <div
      role="menubar"
      data-slot="menubar"
      class={cn(["bg-background flex h-9 items-center gap-1 rounded-md border p-1 shadow-xs", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar_menu(assigns) do
    ~H"""
    <div id={@id} data-slot="menubar-menu" data-state="closed" class={cn(["relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="menubar-trigger"
      phx-click={toggle(@menu)}
      class={
        cn([
          "focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent",
          "data-[state=open]:text-accent-foreground flex items-center rounded-sm px-2 py-1 text-sm",
          "font-medium outline-hidden select-none",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:menu, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar_content(assigns) do
    ~H"""
    <div
      role="menu"
      data-slot="menubar-content"
      hidden
      phx-click-away={close(@menu)}
      phx-window-keydown={close(@menu)}
      phx-key="escape"
      class={
        cn([
          "bg-popover text-popover-foreground absolute top-full left-0 z-50 mt-1 min-w-[12rem]",
          "overflow-hidden rounded-md border p-1 shadow-md",
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
  attr(:inset, :boolean, default: false)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def menubar_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex="-1"
      data-slot="menubar-item"
      data-inset={@inset}
      class={
        cn([
          "focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground",
          "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm",
          "outline-hidden select-none data-[inset=true]:pl-8",
          "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4",
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
  attr(:inset, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar_label(assigns) do
    ~H"""
    <div
      data-slot="menubar-label"
      data-inset={@inset}
      class={cn(["px-2 py-1.5 text-sm font-medium data-[inset=true]:pl-8", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def menubar_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="menubar-separator"
      class={cn(["bg-border -mx-1 my-1 h-px", @class])}
      {@rest}
    />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def menubar_shortcut(assigns) do
    ~H"""
    <span
      data-slot="menubar-shortcut"
      class={cn(["text-muted-foreground ml-auto text-xs tracking-widest", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
