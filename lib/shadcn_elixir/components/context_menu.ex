defmodule ShadcnElixir.Components.ContextMenu do
  @moduledoc """
  ContextMenu — a port of shadcn/ui's
  [Context Menu](https://ui.shadcn.com/docs/components/context-menu).

  Opens on right-click of its trigger area, positioned at the cursor. Dismissed via
  `phx-click-away`. Composed of `context_menu/1`, `context_menu_trigger/1`,
  `context_menu_content/1`, `context_menu_item/1`, `context_menu_label/1`,
  `context_menu_separator/1`, and `context_menu_shortcut/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [close: 1]

  @open_js "event.preventDefault();" <>
             "var m=this.closest('[data-slot=context-menu]').querySelector('[data-slot=context-menu-content]');" <>
             "m.setAttribute('data-state','open');" <>
             "m.style.left=event.offsetX+'px';m.style.top=event.offsetY+'px';"

  # Keyboard equivalent: Shift+F10 or the dedicated ContextMenu key opens the menu
  # at the trigger's top-left, so the menu is reachable without a pointer.
  @open_kbd_js "if(event.key==='ContextMenu'||(event.shiftKey&&event.key==='F10')){" <>
                 "event.preventDefault();" <>
                 "var m=this.closest('[data-slot=context-menu]').querySelector('[data-slot=context-menu-content]');" <>
                 "m.setAttribute('data-state','open');m.style.left='0px';m.style.top='0px';}"

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def context_menu(assigns) do
    ~H"""
    <div id={@id} data-slot="context-menu" data-state="closed" class={cn(["relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def context_menu_trigger(assigns) do
    assigns =
      assigns
      |> assign(:open_js, @open_js)
      |> assign(:open_kbd_js, @open_kbd_js)

    ~H"""
    <div
      data-slot="context-menu-trigger"
      tabindex="0"
      aria-haspopup="menu"
      oncontextmenu={@open_js}
      onkeydown={@open_kbd_js}
      class={cn(@class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def context_menu_content(assigns) do
    ~H"""
    <div
      id={"#{@menu}-content"}
      role="menu"
      aria-orientation="vertical"
      phx-hook="ShadcnMenu"
      data-slot="context-menu-content"
      data-state="closed"
      phx-click-away={close(@menu)}
      phx-window-keydown={close(@menu)}
      phx-key="escape"
      class={
        cn([
          "data-[state=closed]:hidden",
          "bg-popover text-popover-foreground absolute z-50 min-w-[8rem] overflow-hidden",
          "rounded-md border p-1 shadow-md",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95",
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
  attr(:variant, :string, default: "default", values: ["default", "destructive"])
  attr(:inset, :boolean, default: false)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def context_menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex="-1"
      data-slot="context-menu-item"
      data-variant={@variant}
      data-inset={to_string(@inset)}
      class={
        cn([
          "focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground",
          "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm",
          "outline-hidden select-none data-[inset=true]:pl-8",
          "data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50",
          "data-[variant=destructive]:text-destructive",
          "data-[variant=destructive]:focus:bg-destructive/10 data-[variant=destructive]:hover:bg-destructive/10",
          "data-[variant=destructive]:focus:text-destructive data-[variant=destructive]:hover:text-destructive",
          "dark:data-[variant=destructive]:focus:bg-destructive/20 dark:data-[variant=destructive]:hover:bg-destructive/20",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          "[&_svg:not([class*='text-'])]:text-muted-foreground data-[variant=destructive]:*:[svg]:text-destructive!",
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

  def context_menu_label(assigns) do
    ~H"""
    <div
      data-slot="context-menu-label"
      data-inset={to_string(@inset)}
      class={cn(["text-foreground px-2 py-1.5 text-sm font-medium data-[inset=true]:pl-8", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def context_menu_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="context-menu-separator"
      class={cn(["bg-border -mx-1 my-1 h-px", @class])}
      {@rest}
    />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def context_menu_shortcut(assigns) do
    ~H"""
    <span
      data-slot="context-menu-shortcut"
      class={cn(["text-muted-foreground ml-auto text-xs tracking-widest", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
