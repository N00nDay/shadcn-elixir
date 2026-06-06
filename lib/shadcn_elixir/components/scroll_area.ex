defmodule ShadcnElixir.Components.ScrollArea do
  @moduledoc """
  ScrollArea — a port of shadcn/ui's
  [Scroll Area](https://ui.shadcn.com/docs/components/scroll-area).

  A scrollable region with a thin, themed scrollbar.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a scroll area.

  ## Examples

      <.scroll_area class="h-72 w-48 rounded-md border">
        ...long content...
      </.scroll_area>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def scroll_area(assigns) do
    ~H"""
    <div
      data-slot="scroll-area"
      class={
        cn([
          "relative overflow-auto",
          "[&::-webkit-scrollbar]:w-2.5 [&::-webkit-scrollbar]:h-2.5",
          "[&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-thumb]:bg-border",
          "[&::-webkit-scrollbar-track]:bg-transparent",
          "[scrollbar-width:thin] [scrollbar-color:var(--border)_transparent]",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
