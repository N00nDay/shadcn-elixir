defmodule ShadcnElixir.Components.Sheet do
  @moduledoc """
  Sheet — a port of shadcn/ui's [Sheet](https://ui.shadcn.com/docs/components/sheet).

  A panel that slides in from an edge of the screen. Composed of `sheet/1`,
  `sheet_trigger/1`, `sheet_content/1` (with a `side`), `sheet_header/1`,
  `sheet_footer/1`, `sheet_title/1`, `sheet_description/1`, and `sheet_close/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [open_modal: 1, close_modal: 1]
  import ShadcnElixir.Variants

  @content %{
    base:
      "bg-background fixed z-50 flex flex-col gap-4 shadow-lg pointer-events-none " <>
        "transition-transform duration-300 ease-in-out data-[state=open]:duration-500 " <>
        "data-[state=open]:pointer-events-auto",
    variants: %{
      side: %{
        "right" =>
          "inset-y-0 right-0 h-full w-3/4 border-l sm:max-w-sm " <>
            "translate-x-full data-[state=open]:translate-x-0",
        "left" =>
          "inset-y-0 left-0 h-full w-3/4 border-r sm:max-w-sm " <>
            "-translate-x-full data-[state=open]:translate-x-0",
        "top" =>
          "inset-x-0 top-0 h-auto border-b " <>
            "-translate-y-full data-[state=open]:translate-y-0",
        "bottom" =>
          "inset-x-0 bottom-0 h-auto border-t " <>
            "translate-y-full data-[state=open]:translate-y-0"
      }
    },
    default_variants: %{side: "right"}
  }

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet(assigns) do
    ~H"""
    <div id={@id} data-slot="sheet" data-state="closed" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_trigger(assigns) do
    ~H"""
    <span data-slot="sheet-trigger" phx-click={open_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:side, :string, default: "right", values: ["right", "left", "top", "bottom"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_content(assigns) do
    assigns =
      assign(assigns, :content_class, variant(@content, side: assigns.side, class: assigns.class))

    ~H"""
    <div
      id={"#{@dialog}-overlay"}
      data-slot="sheet-overlay"
      data-state="closed"
      phx-click={close_modal(@dialog)}
      class="fixed inset-0 z-50 bg-black/50 opacity-0 pointer-events-none transition-opacity duration-300 data-[state=open]:opacity-100 data-[state=open]:pointer-events-auto"
    >
    </div>
    <div
      id={"#{@dialog}-content"}
      role="dialog"
      aria-modal="true"
      data-slot="sheet-content"
      data-side={@side}
      data-state="closed"
      phx-window-keydown={close_modal(@dialog)}
      phx-key="escape"
      class={@content_class}
      {@rest}
    >
      {render_slot(@inner_block)}
      <button
        type="button"
        phx-click={close_modal(@dialog)}
        aria-label="Close"
        class="ring-offset-background focus:ring-ring absolute top-4 right-4 rounded-xs opacity-70 transition-opacity hover:opacity-100 focus:ring-2 focus:ring-offset-2 focus:outline-hidden disabled:pointer-events-none [&_svg]:size-4"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path d="M18 6 6 18" /><path d="m6 6 12 12" />
        </svg>
        <span class="sr-only">Close</span>
      </button>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_header(assigns) do
    ~H"""
    <div data-slot="sheet-header" class={cn(["flex flex-col gap-1.5 p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_footer(assigns) do
    ~H"""
    <div data-slot="sheet-footer" class={cn(["mt-auto flex flex-col gap-2 p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_title(assigns) do
    ~H"""
    <div data-slot="sheet-title" class={cn(["text-foreground font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_description(assigns) do
    ~H"""
    <div data-slot="sheet-description" class={cn(["text-muted-foreground text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sheet_close(assigns) do
    ~H"""
    <span data-slot="sheet-close" phx-click={close_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
