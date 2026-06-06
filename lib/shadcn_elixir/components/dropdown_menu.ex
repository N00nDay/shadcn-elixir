defmodule ShadcnElixir.Components.DropdownMenu do
  @moduledoc """
  DropdownMenu — a port of shadcn/ui's
  [Dropdown Menu](https://ui.shadcn.com/docs/components/dropdown-menu).

  Toggled with `Phoenix.LiveView.JS`, dismissed via `phx-click-away`. Composed of
  `dropdown_menu/1`, `dropdown_menu_trigger/1`, `dropdown_menu_content/1`,
  `dropdown_menu_group/1`, `dropdown_menu_label/1`, `dropdown_menu_item/1`,
  `dropdown_menu_checkbox_item/1`, `dropdown_menu_radio_item/1`,
  `dropdown_menu_separator/1`, `dropdown_menu_shortcut/1`, and the `*_sub_*` family.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [toggle: 1, close: 1]

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="dropdown-menu"
      data-state="closed"
      class={cn(["relative inline-block text-left", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_trigger(assigns) do
    ~H"""
    <span data-slot="dropdown-menu-trigger" phx-click={toggle(@menu)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:menu, :string, required: true)
  attr(:align, :string, default: "start", values: ["start", "center", "end"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_content(assigns) do
    ~H"""
    <div
      id={"#{@menu}-content"}
      role="menu"
      data-slot="dropdown-menu-content"
      data-state="closed"
      phx-click-away={close(@menu)}
      phx-window-keydown={close(@menu)}
      phx-key="escape"
      class={
        cn([
          "data-[state=closed]:hidden",
          "bg-popover text-popover-foreground absolute top-full z-50 mt-2 min-w-[8rem]",
          "overflow-hidden rounded-md border p-1 shadow-md",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95",
          align_class(@align),
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

  def dropdown_menu_group(assigns) do
    ~H"""
    <div role="group" data-slot="dropdown-menu-group" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:inset, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_label(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-label"
      data-inset={to_string(@inset)}
      class={cn(["px-2 py-1.5 text-sm font-medium data-[inset=true]:pl-8", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:variant, :string, default: "default", values: ["default", "destructive"])
  attr(:inset, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def dropdown_menu_item(assigns) do
    ~H"""
    <.link
      :if={link?(@rest)}
      role="menuitem"
      tabindex="-1"
      data-slot="dropdown-menu-item"
      data-variant={@variant}
      data-inset={to_string(@inset)}
      phx-click={close(@menu)}
      class={item_class(@class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <div
      :if={not link?(@rest)}
      role="menuitem"
      tabindex="-1"
      data-slot="dropdown-menu-item"
      data-variant={@variant}
      data-inset={to_string(@inset)}
      phx-click={close(@menu)}
      class={item_class(@class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_checkbox_item(assigns) do
    ~H"""
    <div
      role="menuitemcheckbox"
      aria-checked={to_string(@checked)}
      tabindex="-1"
      data-slot="dropdown-menu-checkbox-item"
      phx-click={close(@menu)}
      class={cn([item_class(nil), "pl-8", @class])}
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <svg
          :if={@checked}
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-4"
        >
          <path d="M20 6 9 17l-5-5" />
        </svg>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:menu, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_radio_item(assigns) do
    ~H"""
    <div
      role="menuitemradio"
      aria-checked={to_string(@checked)}
      tabindex="-1"
      data-slot="dropdown-menu-radio-item"
      phx-click={close(@menu)}
      class={cn([item_class(nil), "pl-8", @class])}
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <svg :if={@checked} viewBox="0 0 24 24" fill="currentColor" class="size-2">
          <circle cx="12" cy="12" r="10" />
        </svg>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def dropdown_menu_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="dropdown-menu-separator"
      class={cn(["bg-border -mx-1 my-1 h-px", @class])}
      {@rest}
    />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_shortcut(assigns) do
    ~H"""
    <span
      data-slot="dropdown-menu-shortcut"
      class={cn(["text-muted-foreground ml-auto text-xs tracking-widest", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc "A submenu (CSS hover-reveal)."
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_sub(assigns) do
    ~H"""
    <div data-slot="dropdown-menu-sub" class={cn(["group/sub relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:inset, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_sub_trigger(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-sub-trigger"
      data-inset={to_string(@inset)}
      class={cn([item_class(nil), "data-[inset=true]:pl-8", @class])}
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
        class="ml-auto size-4"
      >
        <path d="m9 18 6-6-6-6" />
      </svg>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_sub_content(assigns) do
    ~H"""
    <div
      role="menu"
      data-slot="dropdown-menu-sub-content"
      class={
        cn([
          "bg-popover text-popover-foreground absolute left-full top-0 z-50 ml-1 min-w-[8rem]",
          "overflow-hidden rounded-md border p-1 shadow-lg invisible opacity-0",
          "group-hover/sub:visible group-hover/sub:opacity-100",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp item_class(extra) do
    cn([
      "focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground",
      "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm",
      "outline-hidden select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      "data-[inset=true]:pl-8 data-[variant=destructive]:text-destructive",
      "data-[variant=destructive]:focus:bg-destructive/10 data-[variant=destructive]:hover:bg-destructive/10",
      "data-[variant=destructive]:focus:text-destructive data-[variant=destructive]:hover:text-destructive",
      "dark:data-[variant=destructive]:focus:bg-destructive/20 dark:data-[variant=destructive]:hover:bg-destructive/20",
      "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
      "[&_svg:not([class*='text-'])]:text-muted-foreground data-[variant=destructive]:*:[svg]:text-destructive!",
      extra
    ])
  end

  defp link?(rest) do
    Map.has_key?(rest, :href) or Map.has_key?(rest, :navigate) or Map.has_key?(rest, :patch)
  end

  defp align_class("center"), do: "left-1/2 -translate-x-1/2"
  defp align_class("end"), do: "right-0"
  defp align_class(_), do: "left-0"
end
