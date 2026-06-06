defmodule ShadcnElixir.Components.Kbd do
  @moduledoc """
  Kbd — a port of shadcn/ui's [Kbd](https://ui.shadcn.com/docs/components/kbd).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a keyboard key.

  ## Examples

      <.kbd>⌘</.kbd>
      <.kbd_group><.kbd>Ctrl</.kbd><.kbd>K</.kbd></.kbd_group>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def kbd(assigns) do
    ~H"""
    <kbd
      data-slot="kbd"
      class={
        cn([
          "bg-muted text-muted-foreground pointer-events-none inline-flex h-5 w-fit min-w-5",
          "items-center justify-center gap-1 rounded-sm px-1 font-sans text-xs font-medium select-none",
          "[&_svg:not([class*='size-'])]:size-3",
          "[[data-slot=tooltip-content]_&]:bg-background/20 [[data-slot=tooltip-content]_&]:text-background",
          "dark:[[data-slot=tooltip-content]_&]:bg-background/10",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </kbd>
    """
  end

  @doc "Groups multiple `kbd/1` keys together."
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def kbd_group(assigns) do
    ~H"""
    <kbd data-slot="kbd-group" class={cn(["inline-flex items-center gap-1", @class])} {@rest}>
      {render_slot(@inner_block)}
    </kbd>
    """
  end
end
