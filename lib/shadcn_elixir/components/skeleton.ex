defmodule ShadcnElixir.Components.Skeleton do
  @moduledoc """
  Skeleton — a port of shadcn/ui's
  [Skeleton](https://ui.shadcn.com/docs/components/skeleton).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a placeholder shimmer while content loads.

  ## Examples

      <.skeleton class="h-4 w-[250px]" />
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def skeleton(assigns) do
    ~H"""
    <div
      aria-hidden="true"
      data-slot="skeleton"
      class={cn(["bg-accent animate-pulse rounded-md", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
