defmodule ShadcnElixir.Components.Breadcrumb do
  @moduledoc """
  Breadcrumb — a port of shadcn/ui's
  [Breadcrumb](https://ui.shadcn.com/docs/components/breadcrumb).

  Composed of `breadcrumb/1`, `breadcrumb_list/1`, `breadcrumb_item/1`,
  `breadcrumb_link/1`, `breadcrumb_page/1`, `breadcrumb_separator/1`, and
  `breadcrumb_ellipsis/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a breadcrumb navigation.

  ## Examples

      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item><.breadcrumb_link href="/">Home</.breadcrumb_link></.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item><.breadcrumb_page>Docs</.breadcrumb_page></.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breadcrumb(assigns) do
    ~H"""
    <nav aria-label="breadcrumb" data-slot="breadcrumb" {@rest}>
      {render_slot(@inner_block)}
    </nav>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breadcrumb_list(assigns) do
    ~H"""
    <ol
      data-slot="breadcrumb-list"
      class={
        cn([
          "text-muted-foreground flex flex-wrap items-center gap-1.5 text-sm break-words",
          "sm:gap-2.5",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </ol>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breadcrumb_item(assigns) do
    ~H"""
    <li
      data-slot="breadcrumb-item"
      class={cn(["inline-flex items-center gap-1.5", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def breadcrumb_link(assigns) do
    ~H"""
    <.link
      data-slot="breadcrumb-link"
      class={cn(["hover:text-foreground transition-colors", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breadcrumb_page(assigns) do
    ~H"""
    <span
      role="link"
      aria-disabled="true"
      aria-current="page"
      data-slot="breadcrumb-page"
      class={cn(["text-foreground font-normal", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def breadcrumb_separator(assigns) do
    ~H"""
    <li
      role="presentation"
      aria-hidden="true"
      data-slot="breadcrumb-separator"
      class={cn(["[&>svg]:size-3.5", @class])}
      {@rest}
    >
      <%= if @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path d="m9 18 6-6-6-6" />
        </svg>
      <% end %>
    </li>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def breadcrumb_ellipsis(assigns) do
    ~H"""
    <span
      role="presentation"
      aria-hidden="true"
      data-slot="breadcrumb-ellipsis"
      class={cn(["flex size-9 items-center justify-center", @class])}
      {@rest}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="size-4"
      >
        <circle cx="12" cy="12" r="1" /><circle cx="19" cy="12" r="1" /><circle
          cx="5"
          cy="12"
          r="1"
        />
      </svg>
      <span class="sr-only">More</span>
    </span>
    """
  end
end
