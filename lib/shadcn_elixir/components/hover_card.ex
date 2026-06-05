defmodule ShadcnElixir.Components.HoverCard do
  @moduledoc """
  HoverCard — a port of shadcn/ui's
  [Hover Card](https://ui.shadcn.com/docs/components/hover-card).

  Pure-CSS: reveals a rich card on hover/focus via `group-hover`/`group-focus-within`.
  Composed of `hover_card/1`, `hover_card_trigger/1`, and `hover_card_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def hover_card(assigns) do
    ~H"""
    <span
      data-slot="hover-card"
      class={cn(["group/hover-card relative inline-flex", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def hover_card_trigger(assigns) do
    ~H"""
    <span data-slot="hover-card-trigger" tabindex="0" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :align, :string, default: "center", values: ["start", "center", "end"]
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def hover_card_content(assigns) do
    ~H"""
    <div
      data-slot="hover-card-content"
      data-align={@align}
      class={
        cn([
          "bg-popover text-popover-foreground absolute top-full z-50 mt-2 w-64 rounded-md border",
          "p-4 shadow-md outline-hidden opacity-0 invisible transition-opacity",
          "group-hover/hover-card:opacity-100 group-hover/hover-card:visible",
          "group-focus-within/hover-card:opacity-100 group-focus-within/hover-card:visible",
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

  defp align_class("start"), do: "left-0"
  defp align_class("end"), do: "right-0"
  defp align_class(_), do: "left-1/2 -translate-x-1/2"
end
