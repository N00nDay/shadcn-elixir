defmodule ShadcnElixir.Components.Typography do
  @moduledoc """
  Typography — a port of shadcn/ui's
  [Typography](https://ui.shadcn.com/docs/components/typography) styles.

  shadcn's Typography is a set of class conventions rather than a single component.
  This module exposes them as `typography_*` function components so you can drop in
  consistently-styled prose.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_h1(assigns) do
    ~H"""
    <h1
      class={cn(["scroll-m-20 text-4xl font-extrabold tracking-tight text-balance", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h1>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_h2(assigns) do
    ~H"""
    <h2
      class={
        cn(["scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight first:mt-0", @class])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_h3(assigns) do
    ~H"""
    <h3 class={cn(["scroll-m-20 text-2xl font-semibold tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_h4(assigns) do
    ~H"""
    <h4 class={cn(["scroll-m-20 text-xl font-semibold tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h4>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_p(assigns) do
    ~H"""
    <p class={cn(["leading-7 [&:not(:first-child)]:mt-6", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_blockquote(assigns) do
    ~H"""
    <blockquote class={cn(["mt-6 border-l-2 pl-6 italic", @class])} {@rest}>
      {render_slot(@inner_block)}
    </blockquote>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_list(assigns) do
    ~H"""
    <ul class={cn(["my-6 ml-6 list-disc [&>li]:mt-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_inline_code(assigns) do
    ~H"""
    <code
      class={
        cn([
          "bg-muted relative rounded px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </code>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_lead(assigns) do
    ~H"""
    <p class={cn(["text-muted-foreground text-xl", @class])} {@rest}>{render_slot(@inner_block)}</p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_large(assigns) do
    ~H"""
    <div class={cn(["text-lg font-semibold", @class])} {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_small(assigns) do
    ~H"""
    <small class={cn(["text-sm leading-none font-medium", @class])} {@rest}>
      {render_slot(@inner_block)}
    </small>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def typography_muted(assigns) do
    ~H"""
    <p class={cn(["text-muted-foreground text-sm", @class])} {@rest}>{render_slot(@inner_block)}</p>
    """
  end
end
