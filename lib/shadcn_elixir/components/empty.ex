defmodule ShadcnElixir.Components.Empty do
  @moduledoc """
  Empty — a port of shadcn/ui's [Empty](https://ui.shadcn.com/docs/components/empty).

  An empty-state container. Composed of `empty/1`, `empty_header/1`, `empty_media/1`,
  `empty_title/1`, `empty_description/1`, and `empty_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @media %{
    base: "flex shrink-0 items-center justify-center mb-2 [&_svg:not([class*='size-'])]:size-6",
    variants: %{
      variant: %{
        "default" => "bg-transparent",
        "icon" =>
          "bg-muted text-foreground flex size-10 shrink-0 items-center justify-center rounded-lg"
      }
    },
    default_variants: %{variant: "default"}
  }

  @doc """
  Renders an empty state.

  ## Examples

      <.empty>
        <.empty_header>
          <.empty_media variant="icon"><.icon /></.empty_media>
          <.empty_title>No projects yet</.empty_title>
          <.empty_description>Create your first project to get started.</.empty_description>
        </.empty_header>
        <.empty_content>
          <.button>Create project</.button>
        </.empty_content>
      </.empty>
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty(assigns) do
    ~H"""
    <div
      data-slot="empty"
      class={
        cn([
          "flex min-w-0 flex-1 flex-col items-center justify-center gap-6 rounded-lg",
          "border-dashed p-6 text-center text-balance md:p-12",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_header(assigns) do
    ~H"""
    <div
      data-slot="empty-header"
      class={cn(["flex max-w-sm flex-col items-center gap-2 text-center", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :variant, :string, default: nil, values: [nil, "default", "icon"]
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_media(assigns) do
    assigns = assign(assigns, :class, variant(@media, variant: assigns.variant, class: assigns.class))

    ~H"""
    <div data-slot="empty-media" class={@class} {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_title(assigns) do
    ~H"""
    <div data-slot="empty-title" class={cn(["text-lg font-medium tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_description(assigns) do
    ~H"""
    <div
      data-slot="empty-description"
      class={
        cn([
          "text-muted-foreground [&>a:hover]:text-primary text-sm/relaxed [&>a]:underline",
          "[&>a]:underline-offset-4",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_content(assigns) do
    ~H"""
    <div
      data-slot="empty-content"
      class={
        cn([
          "flex w-full max-w-sm min-w-0 flex-col items-center gap-4 text-sm text-balance",
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
