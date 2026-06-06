defmodule ShadcnElixir.Components.Resizable do
  @moduledoc """
  Resizable — a port of shadcn/ui's
  [Resizable](https://ui.shadcn.com/docs/components/resizable).

  Drag-resizable panels. Dragging is provided by the `ShadcnResizable` JS hook
  (see `assets/js/shadcn_elixir.js`). Composed of `resizable_panel_group/1`,
  `resizable_panel/1`, and `resizable_handle/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)
  attr(:direction, :string, default: "horizontal", values: ["horizontal", "vertical"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def resizable_panel_group(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnResizable"
      data-slot="resizable-panel-group"
      data-direction={@direction}
      class={
        cn([
          "group/rg flex h-full w-full data-[direction=vertical]:flex-col",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:basis, :integer, default: 50, doc: "Initial size as a flex-grow weight.")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def resizable_panel(assigns) do
    ~H"""
    <div
      data-slot="resizable-panel"
      data-part="panel"
      style={"flex: #{@basis} 1 0%;"}
      class={cn(["overflow-hidden", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:with_handle, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def resizable_handle(assigns) do
    ~H"""
    <div
      role="separator"
      tabindex="0"
      aria-label="Resize panel"
      data-slot="resizable-handle"
      data-part="handle"
      class={
        cn([
          "bg-border relative flex w-px shrink-0 items-center justify-center",
          "after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2",
          "focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1",
          "focus-visible:outline-hidden cursor-col-resize select-none",
          "group-data-[direction=vertical]/rg:h-px group-data-[direction=vertical]/rg:w-full",
          "group-data-[direction=vertical]/rg:cursor-row-resize",
          "group-data-[direction=vertical]/rg:after:left-0 group-data-[direction=vertical]/rg:after:h-1",
          "group-data-[direction=vertical]/rg:after:w-full",
          "group-data-[direction=vertical]/rg:after:translate-x-0",
          "group-data-[direction=vertical]/rg:after:-translate-y-1/2",
          "group-data-[direction=vertical]/rg:[&>div]:rotate-90",
          @class
        ])
      }
      {@rest}
    >
      <div
        :if={@with_handle}
        class="bg-border z-10 flex h-4 w-3 items-center justify-center rounded-xs border"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-2.5"
          aria-hidden="true"
        >
          <circle cx="9" cy="12" r="1" /><circle cx="9" cy="5" r="1" /><circle cx="9" cy="19" r="1" />
          <circle cx="15" cy="12" r="1" /><circle cx="15" cy="5" r="1" /><circle cx="15" cy="19" r="1" />
        </svg>
      </div>
    </div>
    """
  end
end
