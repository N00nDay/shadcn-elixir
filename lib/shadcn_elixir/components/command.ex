defmodule ShadcnElixir.Components.Command do
  @moduledoc """
  Command — a port of shadcn/ui's
  [Command](https://ui.shadcn.com/docs/components/command).

  A filterable command palette. Filtering is provided by the `ShadcnCommand` JS hook
  (see `assets/js/shadcn_elixir.js`), which hides non-matching items, hides empty groups,
  and reveals the empty state.

  Composed of `command/1`, `command_input/1`, `command_list/1`, `command_empty/1`,
  `command_group/1`, `command_item/1`, `command_separator/1`, and `command_shortcut/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def command(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnCommand"
      data-slot="command"
      class={
        cn([
          "bg-popover text-popover-foreground flex h-full w-full flex-col overflow-hidden rounded-md",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:placeholder, :string, default: "Type a command or search...")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def command_input(assigns) do
    ~H"""
    <div data-slot="command-input-wrapper" class="flex h-9 items-center gap-2 border-b px-3">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="size-4 shrink-0 opacity-50"
        aria-hidden="true"
      >
        <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
      </svg>
      <input
        type="text"
        data-part="input"
        data-slot="command-input"
        placeholder={@placeholder}
        class={
          cn([
            "placeholder:text-muted-foreground flex h-10 w-full rounded-md bg-transparent py-3",
            "text-sm outline-hidden disabled:cursor-not-allowed disabled:opacity-50",
            @class
          ])
        }
        {@rest}
      />
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def command_list(assigns) do
    ~H"""
    <div
      role="listbox"
      data-part="list"
      data-slot="command-list"
      class={cn(["max-h-[300px] scroll-py-1 overflow-x-hidden overflow-y-auto", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def command_empty(assigns) do
    ~H"""
    <div
      data-part="empty"
      data-slot="command-empty"
      hidden
      class={cn(["py-6 text-center text-sm", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:heading, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def command_group(assigns) do
    ~H"""
    <div data-part="group" data-slot="command-group" class={cn(["text-foreground overflow-hidden p-1", @class])} {@rest}>
      <div :if={@heading} class="text-muted-foreground px-2 py-1.5 text-xs font-medium" data-part="group-heading">
        {@heading}
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:value, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(phx-click href navigate patch))
  slot(:inner_block, required: true)

  def command_item(assigns) do
    ~H"""
    <div
      role="option"
      data-part="item"
      data-value={@value}
      data-slot="command-item"
      class={
        cn([
          "data-[selected=true]:bg-accent data-[selected=true]:text-accent-foreground",
          "hover:bg-accent hover:text-accent-foreground relative flex cursor-default items-center",
          "gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none",
          "data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50",
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
  attr(:rest, :global)

  def command_separator(assigns) do
    ~H"""
    <div role="separator" data-slot="command-separator" class={cn(["bg-border -mx-1 h-px", @class])} {@rest} />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def command_shortcut(assigns) do
    ~H"""
    <span
      data-slot="command-shortcut"
      class={cn(["text-muted-foreground ml-auto text-xs tracking-widest", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
