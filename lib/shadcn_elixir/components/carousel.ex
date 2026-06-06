defmodule ShadcnElixir.Components.Carousel do
  @moduledoc """
  Carousel — a port of shadcn/ui's
  [Carousel](https://ui.shadcn.com/docs/components/carousel).

  A scroll-snap carousel. Previous/next buttons scroll the track via inline JS (works in
  live and dead views). Composed of `carousel/1`, `carousel_content/1`, `carousel_item/1`,
  `carousel_previous/1`, and `carousel_next/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  alias ShadcnElixir.Components.Button

  attr(:id, :string, required: true)
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel(assigns) do
    ~H"""
    <div
      id={@id}
      role="region"
      aria-roledescription="carousel"
      data-slot="carousel"
      data-orientation={@orientation}
      class={cn(["relative", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_content(assigns) do
    ~H"""
    <div data-slot="carousel-content" class="overflow-hidden">
      <div
        data-part="track"
        class={cn(["flex -ml-4 snap-x snap-mandatory scroll-smooth overflow-x-auto", @class])}
        {@rest}
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_item(assigns) do
    ~H"""
    <div
      role="group"
      aria-roledescription="slide"
      data-slot="carousel-item"
      class={cn(["min-w-0 shrink-0 grow-0 basis-full snap-start pl-4", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:carousel, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def carousel_previous(assigns) do
    assigns = assign(assigns, :scroll_js, scroll_js(assigns.carousel, -1))

    ~H"""
    <button
      type="button"
      aria-label="Previous slide"
      data-slot="carousel-previous"
      onclick={@scroll_js}
      class={Button.button_variants(variant: "outline", size: "icon", class: cn(["absolute size-8 rounded-full top-1/2 -left-12 -translate-y-1/2", @class]))}
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
        <path d="m12 19-7-7 7-7" /><path d="M19 12H5" />
      </svg>
    </button>
    """
  end

  attr(:carousel, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def carousel_next(assigns) do
    assigns = assign(assigns, :scroll_js, scroll_js(assigns.carousel, 1))

    ~H"""
    <button
      type="button"
      aria-label="Next slide"
      data-slot="carousel-next"
      onclick={@scroll_js}
      class={Button.button_variants(variant: "outline", size: "icon", class: cn(["absolute size-8 rounded-full top-1/2 -right-12 -translate-y-1/2", @class]))}
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
        <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
      </svg>
    </button>
    """
  end

  defp scroll_js(id, dir) do
    "var t=document.getElementById('#{id}').querySelector('[data-part=track]');" <>
      "t.scrollBy({left:#{dir}*t.clientWidth,behavior:'smooth'});"
  end
end
