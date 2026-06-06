defmodule ShadcnElixir.Components.Collapsible do
  @moduledoc """
  Collapsible — a port of shadcn/ui's
  [Collapsible](https://ui.shadcn.com/docs/components/collapsible).

  Built on native `<details>`/`<summary>`. Composed of `collapsible/1`,
  `collapsible_trigger/1`, and `collapsible_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a collapsible region.

  ## Examples

      <.collapsible>
        <.collapsible_trigger>Toggle</.collapsible_trigger>
        <.collapsible_content>Hidden content</.collapsible_content>
      </.collapsible>
  """
  attr(:open, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def collapsible(assigns) do
    ~H"""
    <details
      open={@open}
      data-slot="collapsible"
      class={cn(["group/collapsible", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </details>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def collapsible_trigger(assigns) do
    ~H"""
    <summary
      data-slot="collapsible-trigger"
      class={
        cn([
          "cursor-pointer list-none select-none marker:hidden [&::-webkit-details-marker]:hidden",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </summary>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def collapsible_content(assigns) do
    ~H"""
    <div data-slot="collapsible-content" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
