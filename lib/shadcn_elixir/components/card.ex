defmodule ShadcnElixir.Components.Card do
  @moduledoc """
  Card — a port of shadcn/ui's [Card](https://ui.shadcn.com/docs/components/card).

  Composed of `card/1` plus `card_header/1`, `card_title/1`, `card_description/1`,
  `card_action/1`, `card_content/1`, and `card_footer/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a card container.

  ## Examples

      <.card>
        <.card_header>
          <.card_title>Title</.card_title>
          <.card_description>Description</.card_description>
        </.card_header>
        <.card_content>Body</.card_content>
        <.card_footer>Footer</.card_footer>
      </.card>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card(assigns) do
    ~H"""
    <div
      data-slot="card"
      class={
        cn([
          "bg-card text-card-foreground flex flex-col gap-6 rounded-xl border py-6 shadow-sm",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_header(assigns) do
    ~H"""
    <div
      data-slot="card-header"
      class={
        cn([
          "@container/card-header grid auto-rows-min grid-rows-[auto_auto] items-start gap-2 px-6",
          "has-data-[slot=card-action]:grid-cols-[1fr_auto] [.border-b]:pb-6",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_title(assigns) do
    ~H"""
    <div data-slot="card-title" class={cn(["leading-none font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_description(assigns) do
    ~H"""
    <div data-slot="card-description" class={cn(["text-muted-foreground text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_action(assigns) do
    ~H"""
    <div
      data-slot="card-action"
      class={cn(["col-start-2 row-span-2 row-start-1 self-start justify-self-end", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_content(assigns) do
    ~H"""
    <div data-slot="card-content" class={cn(["px-6", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def card_footer(assigns) do
    ~H"""
    <div
      data-slot="card-footer"
      class={cn(["flex items-center px-6 [.border-t]:pt-6", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
