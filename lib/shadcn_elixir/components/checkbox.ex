defmodule ShadcnElixir.Components.Checkbox do
  @moduledoc """
  Checkbox — a port of shadcn/ui's
  [Checkbox](https://ui.shadcn.com/docs/components/checkbox).

  Renders a real checkbox (`peer sr-only`) with a styled box and check icon, so it
  submits with forms and toggles with zero JavaScript.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a checkbox.

  ## Examples

      <.checkbox name="terms" />
      <.checkbox name="news" checked />
  """
  attr(:name, :string, default: nil)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled required form id))

  def checkbox(assigns) do
    ~H"""
    <label class={cn(["inline-flex", @class])} data-slot="checkbox">
      <input type="checkbox" name={@name} value={@value} checked={@checked} class="peer sr-only" {@rest} />
      <span class={
        "border-input dark:bg-input/30 peer-checked:bg-primary " <>
          "peer-checked:text-primary-foreground dark:peer-checked:bg-primary " <>
          "peer-checked:border-primary size-4 shrink-0 rounded-[4px] border shadow-xs " <>
          "transition-shadow outline-none flex items-center justify-center " <>
          "peer-focus-visible:border-ring peer-focus-visible:ring-ring/50 peer-focus-visible:ring-[3px] " <>
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50 " <>
          "peer-checked:[&>svg]:opacity-100"
      }>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="3"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-3.5 opacity-0 transition-opacity"
        >
          <path d="M20 6 9 17l-5-5" />
        </svg>
      </span>
    </label>
    """
  end
end
