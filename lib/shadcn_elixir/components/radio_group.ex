defmodule ShadcnElixir.Components.RadioGroup do
  @moduledoc """
  RadioGroup — a port of shadcn/ui's
  [Radio Group](https://ui.shadcn.com/docs/components/radio-group).

  Renders real radio inputs (`peer sr-only`) with styled indicators, so it submits
  with forms and selects with zero JavaScript. Composed of `radio_group/1` and
  `radio_group_item/1` (items share a `name`).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a radio group.

  ## Examples

      <.radio_group>
        <div class="flex items-center gap-2">
          <.radio_group_item id="plan-free" name="plan" value="free" checked />
          <.label for="plan-free">Free</.label>
        </div>
        <div class="flex items-center gap-2">
          <.radio_group_item id="plan-pro" name="plan" value="pro" />
          <.label for="plan-pro">Pro</.label>
        </div>
      </.radio_group>

  The item is a `<label>`, so clicking the dot toggles it; pair it with a sibling
  `<.label for={id}>` (matching the item's `id`) to make the text clickable too.
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def radio_group(assigns) do
    ~H"""
    <div role="radiogroup" data-slot="radio-group" class={cn(["grid gap-3", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:name, :string, required: true)
  attr(:value, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled required form id))

  def radio_group_item(assigns) do
    ~H"""
    <label class={cn(["inline-flex", @class])} data-slot="radio-group-item">
      <input type="radio" name={@name} value={@value} checked={@checked} class="peer sr-only" {@rest} />
      <span class={
        "border-input text-primary dark:bg-input/30 peer-checked:border-primary " <>
          "aspect-square size-4 shrink-0 rounded-full border shadow-xs transition-[color,box-shadow] " <>
          "outline-none flex items-center justify-center " <>
          "peer-focus-visible:border-ring peer-focus-visible:ring-ring/50 peer-focus-visible:ring-[3px] " <>
          "peer-aria-invalid:border-destructive peer-aria-invalid:ring-destructive/20 " <>
          "dark:peer-aria-invalid:ring-destructive/40 " <>
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50 " <>
          "peer-checked:[&>svg]:opacity-100"
      }>
        <svg viewBox="0 0 24 24" fill="currentColor" class="size-2 opacity-0 transition-opacity">
          <circle cx="12" cy="12" r="10" />
        </svg>
      </span>
    </label>
    """
  end
end
