defmodule ShadcnElixir.Components.Accordion do
  @moduledoc """
  Accordion — a port of shadcn/ui's
  [Accordion](https://ui.shadcn.com/docs/components/accordion).

  Built on native `<details>`/`<summary>` for JS-free, accessible disclosure.
  Composed of `accordion/1`, `accordion_item/1`, `accordion_trigger/1`, and
  `accordion_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders an accordion.

  ## Examples

      <.accordion>
        <.accordion_item>
          <.accordion_trigger>Is it accessible?</.accordion_trigger>
          <.accordion_content>Yes. It uses native details/summary.</.accordion_content>
        </.accordion_item>
      </.accordion>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion(assigns) do
    ~H"""
    <div data-slot="accordion" class={cn(@class)} {@rest}>{render_slot(@inner_block)}</div>
    """
  end

  attr(:open, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_item(assigns) do
    ~H"""
    <details
      open={@open}
      data-slot="accordion-item"
      class={cn(["group/accordion border-b last:border-b-0", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </details>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_trigger(assigns) do
    ~H"""
    <summary
      data-slot="accordion-trigger"
      class={
        cn([
          "focus-visible:border-ring focus-visible:ring-ring/50 flex flex-1 items-start",
          "justify-between gap-4 rounded-md py-4 text-left text-sm font-medium transition-all",
          "outline-none hover:underline focus-visible:ring-[3px] cursor-pointer list-none select-none",
          "marker:hidden [&::-webkit-details-marker]:hidden",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
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
        class={
          "text-muted-foreground pointer-events-none size-4 shrink-0 translate-y-0.5 " <>
            "transition-transform duration-200 group-open/accordion:rotate-180"
        }
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </summary>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_content(assigns) do
    ~H"""
    <div data-slot="accordion-content" class="overflow-hidden text-sm" {@rest}>
      <div class={cn(["pt-0 pb-4", @class])}>{render_slot(@inner_block)}</div>
    </div>
    """
  end
end
