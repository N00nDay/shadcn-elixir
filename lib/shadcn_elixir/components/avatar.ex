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
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def avatar(assigns) do
    ~H"""
    <span
      data-slot="avatar"
      class={cn(["relative flex size-8 shrink-0 overflow-hidden rounded-full", @class])}
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
          "bg-muted flex size-full items-center justify-center rounded-full text-sm",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
