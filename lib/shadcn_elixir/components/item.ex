defmodule ShadcnElixir.Components.Item do
  @moduledoc """
  Item — a port of shadcn/ui's [Item](https://ui.shadcn.com/docs/components/item).

  A flexible list/row primitive. Composed of `item_group/1`, `item_separator/1`,
  `item/1`, `item_media/1`, `item_content/1`, `item_title/1`, `item_description/1`,
  `item_actions/1`, `item_header/1`, and `item_footer/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @item %{
    base:
      "group/item flex items-center border border-transparent text-sm rounded-md " <>
        "transition-colors [a&]:hover:bg-accent/50 [a&]:transition-colors duration-100 " <>
        "flex-wrap outline-none focus-visible:border-ring focus-visible:ring-ring/50 " <>
        "focus-visible:ring-[3px]",
    variants: %{
      variant: %{
        "default" => "bg-transparent",
        "outline" => "border-border",
        "muted" => "bg-muted/50"
      },
      size: %{
        "default" => "gap-4 p-4",
        "sm" => "gap-2.5 px-4 py-3"
      }
    },
    default_variants: %{variant: "default", size: "default"}
  }

  @media %{
    base:
      "flex shrink-0 items-center justify-center gap-2 " <>
        "group-has-[[data-slot=item-description]]/item:self-start [&_svg]:pointer-events-none " <>
        "group-has-[[data-slot=item-description]]/item:translate-y-0.5",
    variants: %{
      variant: %{
        "default" => "bg-transparent",
        "icon" => "size-8 border rounded-sm bg-muted [&_svg:not([class*='size-'])]:size-4",
        "image" => "size-10 rounded-sm overflow-hidden [&_img]:size-full [&_img]:object-cover"
      }
    },
    default_variants: %{variant: "default"}
  }

  @doc """
  Renders an item group wrapper.
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_group(assigns) do
    ~H"""
    <div
      data-slot="item-group"
      class={cn(["group/item-group flex flex-col", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def item_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-slot="item-separator"
      class={cn(["bg-border shrink-0 h-px w-full my-0", @class])}
      {@rest}
    />
    """
  end

  @doc """
  Renders an item.

  ## Examples

      <.item variant="outline">
        <.item_media variant="icon"><.icon /></.item_media>
        <.item_content>
          <.item_title>Title</.item_title>
          <.item_description>Description</.item_description>
        </.item_content>
        <.item_actions>...</.item_actions>
      </.item>
  """
  attr(:variant, :string, default: nil, values: [nil, "default", "outline", "muted"])
  attr(:size, :string, default: nil, values: [nil, "default", "sm"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        variant(@item, variant: assigns.variant, size: assigns.size, class: assigns.class)
      )

    ~H"""
    <div data-slot="item" class={@class} {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr(:variant, :string, default: nil, values: [nil, "default", "icon", "image"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_media(assigns) do
    assigns =
      assign(assigns, :class, variant(@media, variant: assigns.variant, class: assigns.class))

    ~H"""
    <div data-slot="item-media" class={@class} {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_content(assigns) do
    ~H"""
    <div
      data-slot="item-content"
      class={cn(["flex flex-1 flex-col gap-1 [&+[data-slot=item-content]]:flex-none", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_title(assigns) do
    ~H"""
    <div
      data-slot="item-title"
      class={cn(["flex w-fit items-center gap-2 text-sm leading-snug font-medium", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_description(assigns) do
    ~H"""
    <div
      data-slot="item-description"
      class={
        cn([
          "text-muted-foreground line-clamp-2 text-sm leading-normal font-normal text-balance",
          "[&>a:hover]:text-primary [&>a]:underline [&>a]:underline-offset-4",
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

  def item_actions(assigns) do
    ~H"""
    <div data-slot="item-actions" class={cn(["flex items-center gap-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_header(assigns) do
    ~H"""
    <div
      data-slot="item-header"
      class={cn(["flex basis-full items-center justify-between gap-2", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def item_footer(assigns) do
    ~H"""
    <div
      data-slot="item-footer"
      class={cn(["flex basis-full items-center justify-between gap-2", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
