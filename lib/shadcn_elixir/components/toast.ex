defmodule ShadcnElixir.Components.Toast do
  @moduledoc """
  Toast — a port of shadcn/ui's (legacy) Toast. For new code prefer
  `ShadcnElixir.Components.Sonner`. This renders a single toast's markup, handy for
  LiveView flash-driven notifications.

  Composed of `toast/1`, `toast_title/1`, `toast_description/1`, `toast_action/1`, and
  `toast_close/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @variants %{
    base:
      "group pointer-events-auto relative flex w-full items-center justify-between gap-4 " <>
        "overflow-hidden rounded-md border p-4 pr-6 shadow-lg",
    variants: %{
      variant: %{
        "default" => "bg-background text-foreground border",
        "destructive" => "destructive group border-destructive bg-destructive text-white"
      }
    },
    default_variants: %{variant: "default"}
  }

  attr(:variant, :string, default: nil, values: [nil, "default", "destructive"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast(assigns) do
    assigns =
      assign(assigns, :class, variant(@variants, variant: assigns.variant, class: assigns.class))

    ~H"""
    <div role="status" aria-live="polite" data-slot="toast" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast_title(assigns) do
    ~H"""
    <div data-slot="toast-title" class={cn(["text-sm font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast_description(assigns) do
    ~H"""
    <div data-slot="toast-description" class={cn(["text-sm opacity-90", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast_action(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="toast-action"
      class={
        cn([
          "ring-offset-background hover:bg-secondary focus:ring-ring inline-flex h-8 shrink-0",
          "items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium",
          "transition-colors focus:ring-2 focus:outline-none disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def toast_close(assigns) do
    ~H"""
    <button
      type="button"
      aria-label="Close"
      data-slot="toast-close"
      class={
        cn([
          "text-foreground/50 hover:text-foreground absolute top-1 right-1 rounded-md p-1",
          "opacity-0 transition-opacity group-hover:opacity-100",
          @class
        ])
      }
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
        <path d="M18 6 6 18" /><path d="m6 6 12 12" />
      </svg>
    </button>
    """
  end
end
