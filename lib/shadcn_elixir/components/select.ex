defmodule ShadcnElixir.Components.Select do
  @moduledoc """
  Select — a port of shadcn/ui's [Select](https://ui.shadcn.com/docs/components/select).

  A custom listbox that writes to a hidden input (so it submits with forms). Interactivity
  is provided by the `ShadcnElixir.Select` JS hook (see `assets/js/shadcn_elixir.js`); the
  hook also works as a standalone initializer for dead views.

  Composed of `select/1`, `select_trigger/1`, `select_value/1`, `select_content/1`,
  `select_group/1`, `select_label/1`, `select_item/1`, and `select_separator/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def select(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnSelect"
      data-slot="select"
      data-state="closed"
      class={cn(["relative inline-block", @class])}
      {@rest}
    >
      <input type="hidden" name={@name} value={@value} data-part="input" />
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:select, :string, required: true)
  attr(:size, :string, default: "default", values: ["default", "sm"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def select_trigger(assigns) do
    ~H"""
    <button
      type="button"
      role="combobox"
      aria-haspopup="listbox"
      aria-expanded="false"
      data-part="trigger"
      data-slot="select-trigger"
      data-size={@size}
      class={
        cn([
          "border-input data-[placeholder]:text-muted-foreground dark:bg-input/30",
          "dark:hover:bg-input/50 flex w-fit items-center justify-between gap-2 rounded-md border",
          "bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs transition-[color,box-shadow]",
          "outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          "disabled:cursor-not-allowed disabled:opacity-50 data-[size=default]:h-9 data-[size=sm]:h-8",
          "*:data-[slot=select-value]:flex *:data-[slot=select-value]:items-center",
          "*:data-[slot=select-value]:gap-2 [&_svg]:pointer-events-none [&_svg]:shrink-0",
          "[&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground",
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
        class="size-4 opacity-50"
        aria-hidden="true"
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </button>
    """
  end

  attr(:placeholder, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def select_value(assigns) do
    ~H"""
    <span
      data-slot="select-value"
      data-part="value"
      data-placeholder={@placeholder}
      class={cn(["pointer-events-none", @class])}
      {@rest}
    >
      {@placeholder}
    </span>
    """
  end

  attr(:select, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def select_content(assigns) do
    ~H"""
    <div
      id={"#{@select}-content"}
      role="listbox"
      data-part="content"
      data-slot="select-content"
      hidden
      class={
        cn([
          "bg-popover text-popover-foreground absolute top-full left-0 z-50 mt-1 max-h-96 min-w-[8rem]",
          "w-full overflow-x-hidden overflow-y-auto rounded-md border p-1 shadow-md",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0",
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

  def select_group(assigns) do
    ~H"""
    <div role="group" data-slot="select-group" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def select_label(assigns) do
    ~H"""
    <div
      data-slot="select-label"
      class={cn(["text-muted-foreground px-2 py-1.5 text-xs", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:select, :string, required: true)
  attr(:value, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def select_item(assigns) do
    ~H"""
    <div
      role="option"
      aria-selected="false"
      data-part="item"
      data-value={@value}
      data-slot="select-item"
      class={
        cn([
          "focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground",
          "relative flex w-full cursor-default items-center gap-2 rounded-sm py-1.5 pr-8 pl-2",
          "text-sm outline-hidden select-none data-[disabled]:pointer-events-none",
          "data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4",
          @class
        ])
      }
      {@rest}
    >
      <span class="absolute right-2 flex size-3.5 items-center justify-center" data-part="check">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-4 hidden"
        >
          <path d="M20 6 9 17l-5-5" />
        </svg>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def select_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="select-separator"
      class={cn(["bg-border pointer-events-none -mx-1 my-1 h-px", @class])}
      {@rest}
    />
    """
  end
end
