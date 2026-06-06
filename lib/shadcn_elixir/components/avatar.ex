defmodule ShadcnElixir.Components.Avatar do
  @moduledoc """
  Avatar — a port of shadcn/ui's [Avatar](https://ui.shadcn.com/docs/components/avatar).

  Composed of `avatar/1`, `avatar_image/1`, and `avatar_fallback/1`. The fallback
  shows automatically when the image is missing or fails to load (the image removes
  itself on error, revealing the fallback beneath it).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders an avatar container.

  ## Examples

      <.avatar>
        <.avatar_image src="https://github.com/shadcn.png" alt="@shadcn" />
        <.avatar_fallback>CN</.avatar_fallback>
      </.avatar>
  """
  attr(:size, :string, default: "default", values: ["default", "sm", "lg"], doc: "Avatar size.")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def avatar(assigns) do
    ~H"""
    <span
      data-slot="avatar"
      data-size={@size}
      class={
        cn([
          "group/avatar relative flex size-8 shrink-0 overflow-hidden rounded-full select-none",
          "data-[size=lg]:size-10 data-[size=sm]:size-6",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:src, :string, required: true)
  attr(:alt, :string, default: "")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def avatar_image(assigns) do
    ~H"""
    <img
      src={@src}
      alt={@alt}
      data-slot="avatar-image"
      onerror="this.remove()"
      class={cn(["absolute inset-0 aspect-square size-full object-cover", @class])}
      {@rest}
    />
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def avatar_fallback(assigns) do
    ~H"""
    <span
      data-slot="avatar-fallback"
      class={
        cn([
          "bg-muted text-muted-foreground flex size-full items-center justify-center rounded-full",
          "text-sm group-data-[size=sm]/avatar:text-xs",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc "Renders a small badge anchored to the bottom-right of an avatar."
  def avatar_badge(assigns) do
    ~H"""
    <span
      data-slot="avatar-badge"
      class={
        cn([
          "absolute right-0 bottom-0 z-10 inline-flex items-center justify-center rounded-full",
          "bg-primary text-primary-foreground ring-2 ring-background select-none",
          "group-data-[size=sm]/avatar:size-2 group-data-[size=sm]/avatar:[&>svg]:hidden",
          "group-data-[size=default]/avatar:size-2.5 group-data-[size=default]/avatar:[&>svg]:size-2",
          "group-data-[size=lg]/avatar:size-3 group-data-[size=lg]/avatar:[&>svg]:size-2",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc "Renders a group of overlapping avatars."
  def avatar_group(assigns) do
    ~H"""
    <div
      data-slot="avatar-group"
      class={
        cn([
          "group/avatar-group flex -space-x-2",
          "*:data-[slot=avatar]:ring-2 *:data-[slot=avatar]:ring-background",
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

  @doc "Renders an overflow count chip for an `avatar_group/1`."
  def avatar_group_count(assigns) do
    ~H"""
    <div
      data-slot="avatar-group-count"
      class={
        cn([
          "relative flex size-8 shrink-0 items-center justify-center rounded-full bg-muted",
          "text-sm text-muted-foreground ring-2 ring-background",
          "group-has-data-[size=lg]/avatar-group:size-10 group-has-data-[size=sm]/avatar-group:size-6",
          "[&>svg]:size-4 group-has-data-[size=lg]/avatar-group:[&>svg]:size-5",
          "group-has-data-[size=sm]/avatar-group:[&>svg]:size-3",
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
