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

  attr :id, :string, required: true
  attr :direction, :string, default: "horizontal", values: ["horizontal", "vertical"]
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def resizable_panel_group(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnResizable"
      data-slot="resizable-panel-group"
      data-direction={@direction}
      class={
        cn([
          "flex h-full w-full data-[direction=vertical]:flex-col",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :basis, :integer, default: 50, doc: "Initial size as a flex-grow weight."
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

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

  attr :with_handle, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  def resizable_handle(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="resizable-handle"
      data-part="handle"
      class={
        cn([
          "bg-border focus-visible:ring-ring relative flex w-px items-center justify-center shrink-0",
          "after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2",
          "cursor-col-resize select-none",
          "group-data-[direction=vertical]/rg:h-px group-data-[direction=vertical]/rg:w-full",
          "group-data-[direction=vertical]/rg:cursor-row-resize",
          @class
        ])
      }
      {@rest}
    >
      <div
        :if={@with_handle}
        class="bg-border z-10 flex h-4 w-3 items-center justify-center rounded-sm border"
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
        >
          <circle cx="9" cy="12" r="1" /><circle cx="9" cy="5" r="1" /><circle cx="9" cy="19" r="1" />
          <circle cx="15" cy="12" r="1" /><circle cx="15" cy="5" r="1" /><circle cx="15" cy="19" r="1" />
        </svg>
      </div>
    </div>
    """
  end
end
