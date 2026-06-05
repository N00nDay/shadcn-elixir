defmodule ShadcnElixir.Components.Pagination do
  @moduledoc """
  Pagination — a port of shadcn/ui's
  [Pagination](https://ui.shadcn.com/docs/components/pagination).

  Composed of `pagination/1`, `pagination_content/1`, `pagination_item/1`,
  `pagination_link/1`, `pagination_previous/1`, `pagination_next/1`, and
  `pagination_ellipsis/1`. Links reuse the Button variant styles.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  alias ShadcnElixir.Components.Button

  @doc """
  Renders a pagination navigation container.

  ## Examples

      <.pagination>
        <.pagination_content>
          <.pagination_item><.pagination_previous href="#" /></.pagination_item>
          <.pagination_item><.pagination_link href="#" is_active>1</.pagination_link></.pagination_item>
          <.pagination_item><.pagination_next href="#" /></.pagination_item>
        </.pagination_content>
      </.pagination>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def pagination(assigns) do
    ~H"""
    <nav
      role="navigation"
      aria-label="pagination"
      data-slot="pagination"
      class={cn(["mx-auto flex w-full justify-center", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </nav>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def pagination_content(assigns) do
    ~H"""
    <ul
      data-slot="pagination-content"
      class={cn(["flex flex-row items-center gap-1", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def pagination_item(assigns) do
    ~H"""
    <li data-slot="pagination-item" {@rest}>{render_slot(@inner_block)}</li>
    """
  end

  attr(:is_active, :boolean, default: false)
  attr(:size, :string, default: "icon")
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def pagination_link(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        Button.button_variants(
          variant: if(assigns.is_active, do: "outline", else: "ghost"),
          size: assigns.size,
          class: assigns.class
        )
      )

    ~H"""
    <.link
      aria-current={if @is_active, do: "page", else: nil}
      data-active={@is_active}
      data-slot="pagination-link"
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))

  def pagination_previous(assigns) do
    ~H"""
    <.pagination_link
      aria-label="Go to previous page"
      size="default"
      class={cn(["gap-1 px-2.5 sm:pl-2.5", @class])}
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
        <path d="m15 18-6-6 6-6" />
      </svg>
      <span class="hidden sm:block">Previous</span>
    </.pagination_link>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))

  def pagination_next(assigns) do
    ~H"""
    <.pagination_link
      aria-label="Go to next page"
      size="default"
      class={cn(["gap-1 px-2.5 sm:pr-2.5", @class])}
      {@rest}
    >
      <span class="hidden sm:block">Next</span>
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
        <path d="m9 18 6-6-6-6" />
      </svg>
    </.pagination_link>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def pagination_ellipsis(assigns) do
    ~H"""
    <span
      aria-hidden="true"
      data-slot="pagination-ellipsis"
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
      <span class="sr-only">More pages</span>
    </span>
    """
  end
end
