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
      class="fixed inset-0 z-50 bg-black/50 opacity-0 pointer-events-none transition-opacity duration-300 data-[state=open]:opacity-100 data-[state=open]:pointer-events-auto"
    >
    </div>
    <div
      id={"#{@dialog}-content"}
      role="dialog"
      aria-modal="true"
      aria-labelledby={"#{@dialog}-title"}
      aria-describedby={"#{@dialog}-description"}
      data-slot="drawer-content"
      data-state="closed"
      phx-window-keydown={close_modal(@dialog)}
      phx-key="escape"
      class={
        cn([
          "group/drawer-content bg-background fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto",
          "max-h-[80vh] flex-col rounded-t-lg border-t pointer-events-none",
          "translate-y-full transition-transform duration-300 ease-in-out",
          "data-[state=open]:translate-y-0 data-[state=open]:pointer-events-auto",
          @class
        ])
      }
      {@rest}
    >
      <div
        aria-hidden="true"
        class="bg-muted mx-auto mt-4 h-2 w-[100px] shrink-0 rounded-full"
      >
      </div>
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

  attr(:dialog, :string,
    default: nil,
    doc: "The drawer id — when set, gives the title a stable id for aria-labelledby."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_title(assigns) do
    ~H"""
    <h2
      id={@dialog && "#{@dialog}-title"}
      data-slot="drawer-title"
      class={cn(["text-foreground font-semibold", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr(:dialog, :string,
    default: nil,
    doc: "The drawer id — when set, gives the description a stable id for aria-describedby."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def drawer_description(assigns) do
    ~H"""
    <p
      id={@dialog && "#{@dialog}-description"}
      data-slot="drawer-description"
      class={cn(["text-muted-foreground text-sm", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
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
