defmodule ShadcnElixir.Components.Tooltip do
  @moduledoc """
  Tooltip — a port of shadcn/ui's
  [Tooltip](https://ui.shadcn.com/docs/components/tooltip).

  Pure-CSS: reveals on hover/focus of the trigger via `group-hover`/`group-focus-within`
  — no JavaScript. Composed of `tooltip/1`, `tooltip_trigger/1`, and `tooltip_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip(assigns) do
    ~H"""
    <span
      data-slot="tooltip"
      class={cn(["group/tooltip relative inline-flex", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip_trigger(assigns) do
    ~H"""
    <span data-slot="tooltip-trigger" tabindex="0" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :side, :string, default: "top", values: ["top", "bottom", "left", "right"]
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip_content(assigns) do
    ~H"""
    <span
      role="tooltip"
      data-slot="tooltip-content"
      class={
        cn([
          "bg-primary text-primary-foreground pointer-events-none absolute z-50 w-fit",
          "rounded-md px-3 py-1.5 text-xs text-balance whitespace-nowrap opacity-0 invisible",
          "transition-opacity group-hover/tooltip:opacity-100 group-hover/tooltip:visible",
          "group-focus-within/tooltip:opacity-100 group-focus-within/tooltip:visible",
          side_class(@side),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp side_class("bottom"), do: "top-full left-1/2 -translate-x-1/2 mt-1.5"
  defp side_class("left"), do: "right-full top-1/2 -translate-y-1/2 mr-1.5"
  defp side_class("right"), do: "left-full top-1/2 -translate-y-1/2 ml-1.5"
  defp side_class(_), do: "bottom-full left-1/2 -translate-x-1/2 mb-1.5"
end
