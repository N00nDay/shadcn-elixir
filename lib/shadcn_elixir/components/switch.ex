defmodule ShadcnElixir.Components.Switch do
  @moduledoc """
  Switch — a port of shadcn/ui's [Switch](https://ui.shadcn.com/docs/components/switch).

  Renders a real checkbox (`peer sr-only`) with `role="switch"` wrapped in a styled
  track + thumb, so it submits with forms and toggles with zero JavaScript while being
  announced as an on/off switch.

  ## Accessibility

  The track/thumb carry no text, so give every switch an accessible name — either an
  `aria-label` or an associated `<.label for={id}>` matching the switch's `id`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a switch.

  ## Examples

      <.switch name="airplane_mode" />
      <.switch name="wifi" checked />
  """
  attr(:name, :string, default: nil)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:size, :string, default: "default", values: ["default", "sm"], doc: "Switch size.")
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled required form id))

  def switch(assigns) do
    ~H"""
    <label class={cn(["inline-flex items-center", @class])} data-slot="switch">
      <input
        type="checkbox"
        role="switch"
        name={@name}
        value={@value}
        checked={@checked}
        aria-checked={to_string(@checked)}
        onchange="this.setAttribute('aria-checked', this.checked)"
        class="peer sr-only"
        {@rest}
      />
      <span data-size={@size} class={
        "group/switch bg-input peer-checked:bg-primary dark:peer-checked:bg-primary " <>
          "dark:bg-input/80 inline-flex shrink-0 items-center rounded-full " <>
          "data-[size=default]:h-[1.15rem] data-[size=default]:w-8 data-[size=sm]:h-3.5 data-[size=sm]:w-6 " <>
          "border border-transparent shadow-xs transition-all outline-none " <>
          "peer-focus-visible:border-ring peer-focus-visible:ring-ring/50 peer-focus-visible:ring-[3px] " <>
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50 " <>
          "peer-checked:[&>[data-slot=switch-thumb]]:translate-x-[calc(100%-2px)] " <>
          "dark:peer-checked:[&>[data-slot=switch-thumb]]:bg-primary-foreground"
      }>
        <span
          data-slot="switch-thumb"
          class={
            "bg-background dark:bg-foreground " <>
              "pointer-events-none block rounded-full ring-0 transition-transform translate-x-0 " <>
              "group-data-[size=default]/switch:size-4 group-data-[size=sm]/switch:size-3"
          }
        >
        </span>
      </span>
    </label>
    """
  end
end
