defmodule ShadcnElixir.Components.InputGroup do
  @moduledoc """
  InputGroup — a port of shadcn/ui's
  [Input Group](https://ui.shadcn.com/docs/components/input-group).

  Composes an input with leading/trailing addons (icons, text, buttons). Composed of
  `input_group/1`, `input_group_addon/1`, `input_group_input/1`, `input_group_textarea/1`,
  `input_group_button/1`, and `input_group_text/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants
  alias ShadcnElixir.Components.Button

  @addon %{
    base:
      "text-muted-foreground flex h-auto cursor-text items-center justify-center gap-2 " <>
        "py-1.5 text-sm font-medium select-none [&>svg:not([class*='size-'])]:size-4 " <>
        "[&>kbd]:rounded-[calc(var(--radius)-5px)] group-data-[disabled=true]/input-group:opacity-50",
    variants: %{
      align: %{
        "inline-start" => "order-first pl-3 has-[>button]:ml-[-0.45rem] has-[>kbd]:ml-[-0.35rem]",
        "inline-end" => "order-last pr-3 has-[>button]:mr-[-0.45rem] has-[>kbd]:mr-[-0.35rem]",
        "block-start" =>
          "order-first w-full justify-start px-3 pt-3 [.border-b]:pb-3 group-has-[>input]/input-group:pt-2.5",
        "block-end" =>
          "order-last w-full justify-start px-3 pb-3 [.border-t]:pt-3 group-has-[>input]/input-group:pb-2.5"
      }
    },
    default_variants: %{align: "inline-start"}
  }

  @doc """
  Renders an input group.

  ## Examples

      <.input_group>
        <.input_group_addon><.icon /></.input_group_addon>
        <.input_group_input placeholder="Search..." />
      </.input_group>
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group(assigns) do
    ~H"""
    <div
      role="group"
      data-slot="input-group"
      class={
        cn([
          "group/input-group border-input dark:bg-input/30 relative flex w-full items-center",
          "rounded-md border shadow-xs transition-[color,box-shadow] outline-none",
          "h-9 min-w-0 has-[>textarea]:h-auto",
          "has-[[data-slot=input-group-control]:focus-visible]:border-ring",
          "has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50",
          "has-[[data-slot=input-group-control]:focus-visible]:ring-[3px]",
          "has-[[data-slot][aria-invalid=true]]:ring-destructive/20",
          "has-[[data-slot][aria-invalid=true]]:border-destructive",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :align, :string,
    default: nil,
    values: [nil, "inline-start", "inline-end", "block-start", "block-end"]

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_addon(assigns) do
    assigns = assign(assigns, :class, variant(@addon, align: assigns.align, class: assigns.class))

    ~H"""
    <div data-slot="input-group-addon" data-align={@align || "inline-start"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :type, :string, default: "text"
  attr :name, :string, default: nil
  attr :value, :any, default: nil
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(placeholder disabled required readonly autocomplete)

  def input_group_input(assigns) do
    ~H"""
    <input
      type={@type}
      name={@name}
      value={@value}
      data-slot="input-group-control"
      class={
        cn([
          "flex-1 rounded-md border-transparent bg-transparent px-3 py-1 text-base shadow-none",
          "outline-none md:text-sm placeholder:text-muted-foreground",
          "disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    />
    """
  end

  attr :name, :string, default: nil
  attr :value, :any, default: nil
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(placeholder disabled required readonly rows)

  def input_group_textarea(assigns) do
    ~H"""
    <textarea
      name={@name}
      data-slot="input-group-control"
      class={
        cn([
          "flex-1 resize-none rounded-md border-transparent bg-transparent px-3 py-2 text-base",
          "shadow-none outline-none md:text-sm placeholder:text-muted-foreground",
          "disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    >{@value}</textarea>
    """
  end

  attr :size, :string, default: "icon-xs"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_button(assigns) do
    assigns =
      assign(assigns,
        :class,
        Button.button_variants(
          variant: "ghost",
          size: if(assigns.size == "icon-xs", do: "icon", else: assigns.size),
          class: cn(["text-sm shadow-none flex gap-2 items-center", assigns.class])
        )
      )

    ~H"""
    <button type="button" data-slot="input-group-button" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_text(assigns) do
    ~H"""
    <span
      data-slot="input-group-text"
      class={
        cn([
          "text-muted-foreground flex items-center gap-2 text-sm",
          "[&_svg:not([class*='size-'])]:size-4",
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
