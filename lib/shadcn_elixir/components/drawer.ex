defmodule ShadcnElixir.Components.Drawer do
  @moduledoc """
  Drawer — a port of shadcn/ui's [Drawer](https://ui.shadcn.com/docs/components/drawer).

  A bottom-anchored panel (the shadcn drawer defaults to bottom). Composed of `drawer/1`,
  `drawer_trigger/1`, `drawer_content/1`, `drawer_header/1`, `drawer_footer/1`,
  `drawer_title/1`, `drawer_description/1`, and `drawer_close/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [open_modal: 1, close_modal: 1]

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer(assigns) do
    ~H"""
    <div id={@id} data-slot="drawer" data-state="closed" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_trigger(assigns) do
    ~H"""
    <span data-slot="drawer-trigger" phx-click={open_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_content(assigns) do
    ~H"""
    <div
      id={"#{@dialog}-overlay"}
      data-slot="drawer-overlay"
      data-state="closed"
      phx-click={close_modal(@dialog)}
      class="fixed inset-0 z-50 bg-black/50 data-[state=closed]:hidden data-[state=open]:animate-in data-[state=open]:fade-in-0"
    >
    </div>
    <div
      id={"#{@dialog}-content"}
      role="dialog"
      aria-modal="true"
      data-slot="drawer-content"
      data-state="closed"
      phx-window-keydown={close_modal(@dialog)}
      phx-key="escape"
      class={
        cn([
          "data-[state=closed]:hidden",
          "bg-background fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto max-h-[80vh] flex-col",
          "rounded-t-lg border data-[state=open]:animate-in data-[state=open]:slide-in-from-bottom",
          @class
        ])
      }
      {@rest}
    >
      <div class="bg-muted mx-auto mt-4 h-2 w-[100px] shrink-0 rounded-full"></div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_header(assigns) do
    ~H"""
    <div
      data-slot="drawer-header"
      class={cn(["flex flex-col gap-1.5 p-4 text-center md:text-left", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_footer(assigns) do
    ~H"""
    <div data-slot="drawer-footer" class={cn(["mt-auto flex flex-col gap-2 p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_title(assigns) do
    ~H"""
    <div data-slot="drawer-title" class={cn(["text-foreground font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_description(assigns) do
    ~H"""
    <div data-slot="drawer-description" class={cn(["text-muted-foreground text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_close(assigns) do
    ~H"""
    <span data-slot="drawer-close" phx-click={close_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
